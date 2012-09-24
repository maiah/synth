#library('synth');

#import('dart:io');
#source('./src/synthesizer.dart');

const String HOST = '127.0.0.1';

final HttpServer _server = new HttpServer();

void route(final String method, final String pathRoute,
           void handler(final HttpRequest req, final Response res)) {
  Function synthHandler = createHandler(handler);
  _server.addRequestHandler((HttpRequest req) {
    return Router.matchPathToRoute(method, pathRoute, req.method, req.path);
  }, synthHandler);
}

void start(final int port) {
  _server.defaultRequestHandler = defaultReqHandler;
  _server.listen(HOST, port);
}

Function createHandler(void handler(final HttpRequest req, final HttpResponse res)) {
  return (final HttpRequest req, final HttpResponse res) {
    Response synthRes = new Response(res);
    handler(req, synthRes);

    if (!synthRes.outputStream.closed) {
      req.inputStream.onClosed =
          () => synthRes.outputStream.close();
    }
  };
}

void defaultReqHandler(final HttpRequest req, final HttpResponse res) {
  res.statusCode = HttpStatus.NOT_FOUND;
  res.headers.set(HttpHeaders.CONTENT_TYPE, "text/plain; charset=UTF-8");
  res.outputStream.write('${res.statusCode} Page not found.'.charCodes());
  res.outputStream.close();
}