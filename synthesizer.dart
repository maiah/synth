#library('synthesizer');

#import('dart:io');

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
      reqPath = _removeLastForwardSlashFromUrl(reqPath);
      route = _removeLastForwardSlashFromUrl(route);
  
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

String _removeLastForwardSlashFromUrl(String path) {
  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}