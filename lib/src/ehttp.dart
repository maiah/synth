// Enhanced HTTP objects.
part of synth;

/** Dart's default HTTP handler method signature. */
typedef void HttpHandler(HttpRequest req, HttpResponse res);

/** Synth's enhanced handler method signature. */
typedef void Handler(Request req, Response res);

/** Enhanced Request object. */
class Request implements HttpRequest {
  final HttpRequest _req;
  final Map<String, String> _dataMap = new Map<String, String>();
  Object dataObj = null;

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
  HttpSession session([init(HttpSession session)]) => _req.session(init);
}

/** Enahnced Response object. */
class Response implements HttpResponse {
  final HttpResponse _res;

  Response(this._res);

  /** Convenient method for writing content in the `Response`#`outputStream`. */
  void write(String content) {
    outputStream.write(content.charCodes);
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
  
  void render( String template ) {
    Render render = new Render( template );
    this.write( render.render() );
  }
}

/** Enhanced Server object. Provides middleware server. */
class Server implements HttpServer {
  HttpServer _server;
  final List<Middleware> _middlewares = new List<Middleware>();

  Server(this._server) {
    _server.defaultRequestHandler = _defaultReqHandler;
  }

  void _defaultReqHandler(final HttpRequest req, final HttpResponse res) {
    res.statusCode = HttpStatus.NOT_FOUND;
    res.headers.set(HttpHeaders.CONTENT_TYPE, "text/plain; charset=UTF-8");
    res.outputStream.write('${res.statusCode} Page not found.'.charCodes);
    res.outputStream.close();
  }

  HttpHandler createHandler(Middleware routeMiddleware, Handler handler) {
    return (final HttpRequest req, final HttpResponse res) {
      // Create enhanced Request and Response object.
      final Request synthReq = new Request(req);
      final Response synthRes = new Response(res);

      // Prepare closing of streams.
      synthReq.inputStream.onClosed = () {
        // Close response stream if needed.
        if (!synthRes.outputStream.closed) {
          synthRes.outputStream.close();
        }
      };

      // Add the user specific route middleware if available.
      List<Middleware> middlewares = new List<Middleware>();
      middlewares.addAll(_middlewares);
      if (routeMiddleware != null) {
        middlewares.add(routeMiddleware);
      }

      // Stack the middlewares.
      if (middlewares.length > 0) {
        var userRequestHandler = ([Error err]) {
          handler(synthReq, synthRes);
        };

        var middleware = ([Error err]) {
          middlewares[middlewares.length - 1](synthReq, synthRes, userRequestHandler);
        };

        if (middlewares.length > 1) {
          for (int i = (middlewares.length - 2); i >= 0; i--) {
            var copyMiddleware = middleware;
            var nextUpMiddleware = ([Error err]) {
              middlewares[i](synthReq, synthRes, copyMiddleware);
            };
            middleware = nextUpMiddleware;
          }
        }

        middleware();

      } else {
        // No middlewares available. Execute user request handler immediately.
        handler(synthReq, synthRes);
      }
    };
  }

  void addMiddleware(Middleware middleware) {
    _middlewares.add(middleware);
  }

  void listen(String host, int port, {int backlog: 128}) => _server.listen(host, port);
  void listenOn(ServerSocket serverSocket) => _server.listenOn(serverSocket);
  addRequestHandler(bool matcher(HttpRequest request),
                    void handler(HttpRequest request, HttpResponse response))
                    => _server.addRequestHandler(matcher, handler);
  void set defaultRequestHandler(
      void handler(HttpRequest request, HttpResponse response)) {
    _server.defaultRequestHandler = handler;
  }
  void close() => _server.close();
  int get port => _server.port;
  void set onError(void callback(e)) {
    _server.onError = callback;
  }

  void set sessionTimeout(int timeout) {
    _server.sessionTimeout = timeout;
  }
}

class Route {
  String _method;
  String _path;
  Middleware _middleware;
  Handler _handler;

  Route(this._method, this._path, this._middleware, this._handler);

  String get method => _method;
  String get path => _path;
  Middleware get middleware => _middleware;
  Handler get handler => _handler;
}

class Router {
  void addRoute(Server server, Route route) {
    HttpHandler httpHandler = server.createHandler(route.middleware, route.handler);
    server.addRequestHandler((HttpRequest req) {
      return _matchPathToRoute(req, route);
    }, httpHandler);
  }

  bool _matchPathToRoute(final HttpRequest req, final Route route) {
    bool matched = false;

    final String routeMethod = route.method;
    String routePath = route.path;

    final String reqMethod = req.method;
    String reqPath = req.path;

    if (routeMethod == reqMethod) {
      reqPath = _removeLastForwardSlashFromPath(reqPath);
      routePath = _removeLastForwardSlashFromPath(routePath);

      List<String> pathNodes = reqPath.split('/');
      List<String> routeNodes = routePath.split('/');

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

  bool _matchPathNodeToRouteNode(final String pathNode, final String routeNode) {
    bool matched = false;
    if (routeNode.startsWith(':')) {
      matched = true;
    } else {
      matched = (pathNode == routeNode);
    }

    return matched;
  }
}