// Middleware collection.

/** Middleware method signature. */
typedef void MiddlewareHandler(Request req, Response res, Middleware next);

class Middleware {
  Request _req;
  Response _res;
  MiddlewareHandler _middlewareHandler;
  Middleware _nextMiddleware;
  Handler _handler;

  Middleware(this._req, this._res, this._middlewareHandler);

  void set nextMiddleware(Middleware nextMiddleware) {
    _nextMiddleware = nextMiddleware;
  }

  void set handler(Handler handler) {
    _handler = handler;
  }

  void execute([Error err]) {
    if (_middlewareHandler != null) {
      _middlewareHandler(_req, _res, _nextMiddleware);
    } else {
      _handler(_req, _res);
    }
  }
}

void logPath(Request req, Response res, Middleware next) {
  final String path = _removeLastForwardSlashFromPath(req.path);
  String params = 'no';

  if (req.queryParameters.length > 0) {
    params = req.queryParameters.toString();
  }

  print('Request path ${path} with $params parameters');
  next.execute();
}

/**
 * Middleware for parsing the request post data
 * and making it available in `Request`#`dataMap` property.
 */
void reqContent(Request req, Response res, Middleware next) {
  final List<int> data = new List<int>();

  req.inputStream.onData = () {
    data.addAll(req.inputStream.read());
    String dataString = new String.fromCharCodes(data);

    final List<String> keysValues = dataString.split('&');
    for (String kv in keysValues) {
      List<String> kvs = kv.split('=');

      final String key = kvs[0];
      final String val = kvs[1];
      req.dataMap[key] = val;
    }
    next.execute();
  };

  req.inputStream.onError = (err) {
    next.execute(err);
  };

  if ('POST' != req.method) {
    next.execute();
  }
}