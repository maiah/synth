import '../lib/synth.dart';

void main() {
    synthInit(webRoot: 'example/webapp/');
    route('GET', '/myroute', (req, res) => myRouteHandler(req, res));

    start(port: 7000);
    print('Listening on port 7000');
  }

  void myRouteHandler(req, res) {
    res.write('REST path ${req.path}');
  }

