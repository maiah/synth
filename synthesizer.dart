#library('synthesizer');

#import('dart:io');

final Map getRoutes = new Map();
final Map postRoutes = new Map();

void get(final String path, void handler(final HttpRequest req, final SynthResponse res)) {
  getRoutes[path] = handler;
}

void post(final path, final callback) {
  postRoutes[path] = callback;
}

Map retrieveRouteMap(final String method) {
  Map routeMap = null;
  if ('GET' == method) {
    routeMap = getRoutes;
  } else if ('POST' == method) {
    routeMap = postRoutes;
  }
  return routeMap;
}

class SynthResponse implements HttpResponse {
  HttpResponse _res;

  SynthResponse(this._res);

  void write(String content) {
    outputStream.write(content.charCodes());
  }

  int get contentLength => _res.contentLength;
  int get statusCode => _res.statusCode;
  String get reasonPhrase => _res.reasonPhrase;
  bool get persistentConnection => _res.persistentConnection;
  HttpHeaders get headers => _res.headers;
  List<Cookie> get cookies => _res.cookies;
  OutputStream get outputStream => _res.outputStream;
  DetachedSocket detachSocket() => _res.detachSocket();
  HttpConnectionInfo get connectionInfo => _res.connectionInfo;
}

class SynthHandler {
  String _path;
  var _handler;

  SynthHandler(this._path, this._handler);

  String get path => _path;
  get handler => _handler;
}

class Router {

  static SynthHandler matchHandler(final HttpRequest req) {
    SynthHandler handler = null;
    final Map routeMap = retrieveRouteMap(req.method);
    final String path = req.path;

    if ('/' == path) {
      handler = new SynthHandler(path, routeMap['/']);
    } else {
      handler = matchPathToRoutes(path, routeMap);
    }

    return handler;
  }

  static SynthHandler matchPathToRoutes(final String path, final Map routeMap) {
    SynthHandler handler = null;
    Collection<String> routes = routeMap.getKeys();
    for (String route in routes) {
      bool matched = matchPathToRoute(path, route);

      if (matched) {
        handler = new SynthHandler(route, routeMap[route]);
        break;
      }
    }

    return handler;
  }

  static bool matchPathToRoute(String path, String route) {
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
        if (!matched) {
          break;
        }
      }
    }

    return matched;
  }

  static bool matchPathNodeToRouteNode(final String pathNode, final String routeNode) {
    bool matched = false;
    if (routeNode.startsWith(':')) {
      matched = true;
    } else {
      matched = pathNode == routeNode;
    }

    return matched;
  }

}

String removeLastForwardSlashFromUrl(String path) {
  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}