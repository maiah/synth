#library('synth');

#import('dart:io');
#import('synthesizer.dart', prefix: 'synthesizer');

const String GET = synthesizer.GET;
const String POST = synthesizer.POST;

void route(final String method, final String path,
           void handler(final HttpRequest req,final synthesizer.Response res))
  => synthesizer.route(method, path, handler);

void start(final int port) {
  final server = new HttpServer();
  server.listen('127.0.0.1', port);
  server.defaultRequestHandler = _defReqHandler;
}

void _defReqHandler(final HttpRequest req, final HttpResponse res) {
  final synthesizer.Response synthRes = new synthesizer.Response(res);
  final synthesizer.Handler synthHandler = synthesizer.Router.matchHandler(req);

  _executeHandler(synthHandler, req, synthRes);

  if (!synthRes.outputStream.closed) {
    req.inputStream.onClosed =
        () => synthRes.outputStream.close();
  }
}

void _executeHandler(synthesizer.Handler synthHandler, HttpRequest req,
                    synthesizer.Response synthRes) {
  if (synthHandler != null) {
    synthHandler.handler(req, synthRes);
  } else {
    _def404Handler(synthRes);
  }
}

void _def404Handler(final synthesizer.Response synthRes) {
  synthRes.statusCode = HttpStatus.NOT_FOUND;
  synthRes.outputStream.write('Page not found.'.charCodes());
}