library synth;

import 'dart:io';
import 'dart:json';

part 'src/utils.dart';
part 'src/middleware.dart';
part 'src/ehttp.dart';
part 'src/render.dart';

// Private variables
Server _server;
final Router _router = new Router();

void synthInit({String webRoot: 'webapp/'}) {
  _server = new Server(new HttpServer(), webRoot);
}

void route(final String method, final String path, middleware,
           [Handler handler]) {
  if (_server == null) {
    throw new StateError('Synth not initialized. Please call synthInit first');
  }
  if (handler == null) {
    handler = middleware;
    middleware = null;
  }

  _router.addRoute(_server, new Route(method, path, middleware, handler));
}

void start({int port: 7000, String host: '127.0.0.1'}) {
  if (_server == null) {
    throw new StateError('Synth not initialized. Please call synthInit first');
  }
  _server.listen(host, port);
}

void use(final Middleware middleware) {
  if (_server == null) {
    throw new StateError('Synth not initialized. Please call synthInit first');
  }
  _server.addMiddleware(middleware);
}