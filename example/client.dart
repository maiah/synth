import '../lib/synth.dart';

main() {
  use((req, res, next) {
    print('Midi player...');
    next();
  });

  use(logPath);

  use(reqContent);

  route('GET', '/', (req, res)
      => res.write('Hello, synthesizers!'));

  route('GET', '/hey', (req, res)
      => res.write('yo'));

  route('GET', '/person/:name', (req, res) {
    var name = req.path.split('/')[2];
    res.write('Hello, $name');
  });

  route('GET', '/login', (req, res) {
    res.write(
        '''
        <!DOCTYPE html>
        <html>
        <body>
        <form action="/login" method="POST">
        <input type="text" name="username" placeholder="Username" /><br />
        <input type="password" name="password" placeholder="Password" /><br />
        <input type="submit" value="Login" />
        </form>
        </body>
        </html>
        '''
        );
  });

  route('POST', '/login', (req, res) {
    print('posting login.');
    res.write("Hello ${req.dataMap['username']}");
  });

  var consoleGreeter = (req, res, next) {
    print('Hello, World!');
    next();
  };

  route('GET', '/hello', consoleGreeter, (req, res)
      => res.write('Hello, World!'));

  start(port: 7000);
  print('Listening on port 7000...');
}
