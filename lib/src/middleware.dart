// Middleware collection.
part of synth;

/** Middleware handler method signature. */
typedef void Middleware(Request req, Response res, next);

void logPath(Request req, Response res, next) {
  final String path = _removeLastForwardSlashFromPath(req.path);
  String params = 'no';

  if (req.queryParameters.length > 0) {
    params = req.queryParameters.toString();
  }

  print('Request path ${path} with $params parameters');
  next();
}

void reqContent(Request req, Response res, next) {
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
    req.dataObj = req.dataMap;
    next();
  };

  req.inputStream.onError = (err) {
    next(err);
  };

  if ('POST' != req.method) {
    next();
  }
}

void reqJsonContent(Request req, Response res, next) {
  final List<int> data = new List<int>();

  req.inputStream.onData = () {
    data.addAll(req.inputStream.read());
    String dataString = new String.fromCharCodes(data);
    req.dataObj = JSON.parse(dataString);
    next();
  };

  req.inputStream.onError = (err) {
    next(err);
  };

  if ('POST' != req.method || req.headers.contentType.subType != 'json') {
    next();
  }
}