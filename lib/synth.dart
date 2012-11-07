library synth;

import 'dart:io';
import 'dart:json';

part 'src/utils.dart';
part 'src/middleware.dart';
part 'src/ehttp.dart';
part 'src/render.dart';

// Private variables
final Server _server = new Server(new HttpServer());
final Router _router = new Router();

void route(final String method, final String path, middleware,
           [Handler handler]) {
  if (handler == null) {
    handler = middleware;
    middleware = null;
  }

  _router.addRoute(_server, new Route(method, path, middleware, handler));
}

void start({int port: 7000, String host: '127.0.0.1'}) {
  _server.listen(host, port);
}

void use(final Middleware middleware) {
  _server.addMiddleware(middleware);
}