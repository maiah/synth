#import('synth.dart');

main() {

  get('/', (req, res)
      => res.write('Hello, synthesizers!'));

  get('/hey', (req, res)
      => res.write('yo'));

  get('/person/:name/dept', (req, res) {
    var name = req.path.split('/')[2];
    res.write('Hello, $name');
  });

  start(7000);
  print('Synthesizing on port 7000...');

}