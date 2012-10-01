#library('synth');

#import('dart:io');

// Typesdefs
typedef bool Middleware(HttpRequest req, Response res);
typedef void Handler(HttpRequest req, HttpResponse res);

// Constants
const String HOST = '127.0.0.1';

// Private variables
final HttpServer _server = new HttpServer();
final List<Middleware> _middlewares = new List<Middleware>();

void route(final String method, final String pathRoute,
           void handler(final HttpRequest req, final Response res)) {
  Handler synthHandler = createHandler(handler);
  _server.addRequestHandler((HttpRequest req) {
    return Router.matchPathToRoute(method, pathRoute, req.method, req.path);
  }, synthHandler);
}

void start(final int port) {
  _server.defaultRequestHandler = _defaultReqHandler;
  _server.listen(HOST, port);
}

void use(Middleware middleware) {
  _middlewares.add(middleware);
}

Handler createHandler(void handler(final HttpRequest req, final HttpResponse res)) {
  return (final HttpRequest req, final HttpResponse res) {
    // Create enhanced Response object.
    Response synthRes = new Response(res);


    // Execute middlewares if any.
    bool executeNext = false;
    for (Middleware middleware in _middlewares) {
      executeNext = middleware(req, synthRes);
      if (!executeNext) {
        break;
      }
    }

    req.inputStream.onClosed = () {

      // Finally execute user handler.
      if (executeNext) {
        handler(req, synthRes);
      }

      // Close response stream if needed.
      if (!synthRes.outputStream.closed) {
        synthRes.outputStream.close();
      }
    };

  };
}

void _defaultReqHandler(final HttpRequest req, final HttpResponse res) {
  res.statusCode = HttpStatus.NOT_FOUND;
  res.headers.set(HttpHeaders.CONTENT_TYPE, "text/plain; charset=UTF-8");
  res.outputStream.write('${res.statusCode} Page not found.'.charCodes());
  res.outputStream.close();
}

class Response implements HttpResponse {
  HttpResponse _res;

  Response(this._res);

  void write(String content) {
    outputStream.write(content.charCodes());
  }

  int get contentLength => _res.contentLength;
  void set contentLength(int contentLength) {
    _res.contentLength = contentLength;
  }

  int get statusCode => _res.statusCode;
  void set statusCode(int statusCode) {
    _res.statusCode = statusCode;
  }

  String get reasonPhrase => _res.reasonPhrase;
  void set reasonPhrase(String reasonPhrase) {
    _res.reasonPhrase = reasonPhrase;
  }

  bool get persistentConnection => _res.persistentConnection;
  HttpHeaders get headers => _res.headers;
  List<Cookie> get cookies => _res.cookies;
  OutputStream get outputStream => _res.outputStream;
  DetachedSocket detachSocket() => _res.detachSocket();
  HttpConnectionInfo get connectionInfo => _res.connectionInfo;
}

class Router {
  static bool matchPathToRoute(final String method, String route, final String reqMethod, String reqPath) {
    bool matched = false;

    if (method == reqMethod) {
      reqPath = _removeLastForwardSlashFromPath(reqPath);
      route = _removeLastForwardSlashFromPath(route);

      List<String> pathNodes = reqPath.split('/');
      List<String> routeNodes = route.split('/');

      if (pathNodes.length == routeNodes.length) {
        for (int i = 0; i < pathNodes.length; i++) {
          final String pathNode = pathNodes[i];
          final String routeNode = routeNodes[i];
          matched = _matchPathNodeToRouteNode(pathNode, routeNode);
          if (!matched) {
            break;
          }
        }
      }
    }

    return matched;
  }

  static bool _matchPathNodeToRouteNode(final String pathNode, final String routeNode) {
    bool matched = false;
    if (routeNode.startsWith(':')) {
      matched = true;
    } else {
      matched = (pathNode == routeNode);
    }

    return matched;
  }
}

// Utils
String _removeLastForwardSlashFromPath(String path) {
  return path.length > 1 && path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}


// Middlewares

/** Middlware for logging request path and its query parameters. */
bool logPath(HttpRequest req, Response res) {
  final String path = _removeLastForwardSlashFromPath(req.path);
  String params = 'no';

  if (req.queryParameters.length > 0) {
    params = req.queryParameters.toString();
  }

  print('Request path ${path} with $params parameters');
  return true;
}

Map<String, String> dataMap = new Map<String, String>();

/** Middleware for parsing the request post data. */
bool reqContent(HttpRequest req, Response res) {
  final List<int> data = new List<int>();

  req.inputStream.onData = () {
    data.addAll(req.inputStream.read());
    String dataString = new String.fromCharCodes(data);

    final List<String> keysValues = dataString.split('&');
    for (String kv in keysValues) {
      List<String> kvs = kv.split('=');

      final String key = kvs[0];
      final String val = kvs[1];
      dataMap[key] = val;
    }
  };

  return true;
}