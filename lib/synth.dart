#library('synth');

#import('dart:io');

#source('src/utils.dart');
#source('src/middleware.dart');
#source('src/ehttp.dart');

// Constants
const String HOST = '127.0.0.1';

// Private variables
final Server _server = new Server(new HttpServer());
final Router _router = new Router();

void route(final String method, final String path, Middleware middleware, [Handler handler]) {
  if (handler == null) {
    handler = middleware;
    middleware = null;
  }

  _router.addRoute(_server, new Route(method, path, middleware, handler));
}

void start(final int port) {
  _server.listen(HOST, port);
}

void use(final Middleware middleware) {
  _server.addMiddleware(middleware);
}