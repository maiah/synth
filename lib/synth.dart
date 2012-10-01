#library('synth');

#import('dart:io');

#source('src/utils.dart');
#source('src/middleware.dart');
#source('src/ehttp.dart');

// Typesdefs
typedef bool Middleware(Request req, Response res);
typedef void Handler(Request req, Response res);

// Constants
const String HOST = '127.0.0.1';

// Private variables
final HttpServer _server = new HttpServer();
final List<Middleware> _middlewares = new List<Middleware>();

void route(final String method, final String pathRoute,
           void handler(final Request req, final Response res)) {
  Handler synthHandler = _createHandler(handler);
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

Handler _createHandler(void handler(final Request req, final Response res)) {
  return (final HttpRequest req, final HttpResponse res) {
    // Create enhanced Request and Response object.
    Request synthReq = new Request(req);
    Response synthRes = new Response(res);


    // Execute middlewares if any.
    bool executeNext = false;
    for (Middleware middleware in _middlewares) {
      executeNext = middleware(synthReq, synthRes);
      if (!executeNext) {
        break;
      }
    }

    synthReq.inputStream.onClosed = () {

      // Finally execute user handler.
      if (executeNext) {
        handler(synthReq, synthRes);
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