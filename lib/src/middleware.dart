// Middleware collection.

/** Middlware for logging request path and its query parameters. */
bool logPath(Request req, Response res) {
  final String path = _removeLastForwardSlashFromPath(req.path);
  String params = 'no';

  if (req.queryParameters.length > 0) {
    params = req.queryParameters.toString();
  }

  print('Request path ${path} with $params parameters');
  return true;
}

/**
 * Middleware for parsing the request post data
 * and making it available in `Request`#`dataMap` property.
 */
bool reqContent(Request req, Response res) {
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
  };

  return true;
}