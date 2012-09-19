#import('synth.dart', prefix: 'synth');

main() {

  synth.get('/', (req, res)
      => res.write('Hello, synthesizers!'));

  synth.get('/hey', (req, res)
      => res.write('yo'));

  synth.get('/person/:name/dept', (req, res) {
    var name = req.path.split('/')[2];
    res.write('Hello, $name');
  });

  synth.synthesize(7000);
  print('Synthesizing on port 7000...');

}