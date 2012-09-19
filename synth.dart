#library('synth');

#import('dart:io');
#import('synthesizer.dart');

final Map getRoutes = new Map();
final Map postRoutes = new Map();

void get(final String path, void handler(final HttpRequest req, final SynthResponse res)) {
  getRoutes[path] = handler;
}

void post(final path, final callback) {
  postRoutes[path] = callback;
}

void defReqHandler(final HttpRequest req, final HttpResponse res) {
  bool found = false;

  if ('GET' == req.method) {
    var callback = matchHandler(req.path);
    found = executeHandler(callback, req, res);
  }

  if (!found) {
    def404Handler(res);
  }

  res.outputStream.close();
}

matchHandler(String path) {
  var handler = null;

  if ('/' == path) {
    handler = getRoutes[path];

  } else {
    path = removeLastForwardSlashFromUrl(path);
    List<String> nodes = path.split('/');
    String rootNode = '/${nodes[1]}';
    Collection<String> keys = getRoutes.getKeys();
    for (String key in keys) {
      if (key.startsWith(rootNode)) {
        List<String> noses = key.split('/');
        if (noses.length == nodes.length) {
          handler = getRoutes[key];
        }
      }
    }
  }

  return handler;
}

class SynthHandler {
  String _path;
  var _handler;

  SynthHandler(this._path, this._handler);

  String get path => _path;
  get handler => _handler;
}

SynthHandler matchHandler2(final String path) {
  SynthHandler handler = null;

  if ('/' == path) {
    handler = new SynthHandler(path, getRoutes['/']);
  } else {
    handler = matchPathToRoutes(path);
  }

  return handler;
}

SynthHandler matchPathToRoutes(final String path) {
  SynthHandler handler = null;
  Collection<String> routes = getRoutes.getKeys();
  for (String route in routes) {
    bool matched = matchPathToRoute(path, route);

    if (matched) {
      handler = new SynthHandler(route, getRoutes[route]);
      break;
    }
  }

  return handler;
}

bool matchPathToRoute(String path, String route) {
  bool matched = false;

  SynthHandler handler = null;
  path = removeLastForwardSlashFromUrl(path);
  route = removeLastForwardSlashFromUrl(route);

  List<String> pathNodes = path.split('/');
  List<String> routeNodes = route.split('/');

  if (pathNodes.length == routeNodes.length) {
    for (int i = 0; i < pathNodes.length; i++) {
      final String pathNode = pathNodes[i];
      final String routeNode = routeNodes[i];
      matched = matchPathNodeToRouteNode(pathNode, routeNode);
    }
  }

  return matched;
}

bool matchPathNodeToRouteNode(final String pathNode, final String routeNode) {
  bool matched = false;
  if (routeNode.startsWith(':')) {
    matched = true;
  } else {
    matched = pathNode == routeNode;
  }

  return matched;
}

String removeLastForwardSlashFromUrl(String path) {
  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}

bool executeHandler(void handler(final HttpRequest request, final SynthResponse response),
               final HttpRequest req, final HttpResponse res) {
  bool found = false;
  if (handler != null) {
    final synthRes = new SynthResponse(res);
    handler(req, synthRes);
    found = true;
  }
  return found;
}

void def404Handler(final HttpResponse res) {
  res.statusCode = HttpStatus.NOT_FOUND;
  res.outputStream.write('Page not found.'.charCodes());
}

void synthesize(final int port) {
  final server = new HttpServer();
  server.listen('127.0.0.1', port);
  server.defaultRequestHandler = defReqHandler;
}