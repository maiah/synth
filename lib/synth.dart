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

void route(final String method, final String path, Handler handler) {

  _router.addRoute(_server, new Route(method, path, handler));
}

void start(final int port) {
  _server.listen(HOST, port);
}

void use(final Middleware middleware) {
  _server.addMiddleware(middleware);
}