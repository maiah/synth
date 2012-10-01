// Enhanced HTTP objects.

/** Enhanced Request object. */
class Request implements HttpRequest {
  final HttpRequest _req;
  final Map<String, String> _dataMap = new Map<String, String>();

  Request(this._req);

  /**
   * Holds the request POST data. This is populated
   * by `reqContent` middleware.
   */
  Map<String, String> get dataMap => _dataMap;

  int get contentLength => _req.contentLength;

  bool get persistentConnection => _req.persistentConnection;
  String get method => _req.method;
  String get uri => _req.uri;
  String get path => _req.path;
  String get queryString => _req.queryString;
  Map<String, String> get queryParameters => _req.queryParameters;
  HttpHeaders get headers => _req.headers;
  List<Cookie> get cookies => _req.cookies;
  InputStream get inputStream => _req.inputStream;
  String get protocolVersion => _req.protocolVersion;
  HttpConnectionInfo get connectionInfo => _req.connectionInfo;
}

/** Enahnced Response object. */
class Response implements HttpResponse {
  final HttpResponse _res;

  Response(this._res);

  /** Convenient method for writing content in the `Response`#`outputStream`. */
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