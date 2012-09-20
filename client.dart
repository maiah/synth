#import('dart:io');
#import('synth.dart');

main() {

  get('/', (req, res)
      => res.write('Hello, synthesizers!'));

  get('/hey', (req, res)
      => res.write('yo'));

  get('/person/:name', (req, res) {
    var name = req.path.split('/')[2];
    res.write('Hello, $name');
  });

  get('/login', (req, res) {
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

  post('/login', (HttpRequest req, res) {
    req.inputStream.pipe(res.outputStream);
  });

  start(7000);
  print('Synthesizing on port 7000...');

}