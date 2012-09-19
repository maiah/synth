#library('synthesizer');

#import('dart:io');

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