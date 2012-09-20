#library('synth');

#import('dart:io');
#import('synthesizer.dart', prefix: 'synthesizer');

void get(final String path, void handler(final HttpRequest req, final synthesizer.SynthResponse res))
  => synthesizer.get(path, handler);

void post(final path, final callback)
  => synthesizer.post(path, callback);

void defReqHandler(final HttpRequest req, final HttpResponse res) {
  bool found = false;

  if ('GET' == req.method) {
    synthesizer.SynthHandler synthHandler = synthesizer.Router.matchHandler(req.path);
    found = executeHandler(synthHandler, req, res);
  }

  if (!found) {
    def404Handler(res);
  }

  res.outputStream.close();
}

bool executeHandler(synthesizer.SynthHandler synthHandler, final HttpRequest req, final HttpResponse res) {
  bool found = false;
  if (synthHandler != null) {
    final synthRes = new synthesizer.SynthResponse(res);
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