import '../lib/synth.dart';

void main() {
    synthInit(webRoot: 'example/webapp/');
    route('GET', '/query', (req, res) => idolQueryServe(req, res));

    start(port: 7000);
    print('Listening on port 7000');
  }

  void fileServe(req, res) {
    res.write('Hello, World!');
  }

  void idolQueryServe(req, res) {
    res.write('REST path ${req.path}');
  }

