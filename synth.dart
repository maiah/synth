#library('synth');

#import('dart:io');
#import('synthesizer.dart', prefix: 'synthesizer');

const String GET = synthesizer.GET;
const String POST = synthesizer.POST;

void route(final String method, final String path, void handler(final HttpRequest req, final synthesizer.SynthResponse res))
  => synthesizer.route(method, path, handler);

void defReqHandler(final HttpRequest req, final HttpResponse res) {
  final synthesizer.SynthResponse synthRes = new synthesizer.SynthResponse(res);
  final synthesizer.SynthHandler synthHandler = synthesizer.Router.matchHandler(req);
  bool found = executeHandler(synthHandler, req, synthRes);

  if (!found) {
    def404Handler(res);
  }

  if (!res.outputStream.closed) {
    req.inputStream.onClosed =
        () => res.outputStream.close();
  }
}

bool executeHandler(synthesizer.SynthHandler synthHandler, final HttpRequest req,
                    final synthesizer.SynthResponse synthRes) {
  bool found = false;
  if (synthHandler != null) {
    synthHandler.handler(req, synthRes);
    found = true;
  }
  return found;
}

void def404Handler(final HttpResponse res) {
  res.statusCode = HttpStatus.NOT_FOUND;
  res.outputStream.write('Page not found.'.charCodes());
}

void start(final int port) {
  final server = new HttpServer();
  server.listen('127.0.0.1', port);
  server.defaultRequestHandler = defReqHandler;
}