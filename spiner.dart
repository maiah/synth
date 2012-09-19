#import('synth.dart', prefix: 'synth');

main() {
  synth.get('/', (req, res) => res.write('This is root'));
  synth.get('/hey', (req, res) => res.write('yo'));
  synth.get('/person', (req, res) => res.write('Hello, there'));
  synth.get('/person/:name', (req, res) => res.write('Hello, <Name>'));
  synth.get('/employee/:name/department/:id', (req, res) => res.write('Hello, dept'));

  synth.SynthHandler handler = synth.matchHandler2('/');
  print('"/" =? "${handler.path}", handler = ${handler.handler}');

  handler = synth.matchHandler2('/hey');
  print('"/hey" =? "${handler.path}"');

  handler = synth.matchHandler2('/person');
  print('"/person" =? "${handler.path}"');

  handler = synth.matchHandler2('/person/maiah/');
  print('"/person/:name" =? "${handler.path}"');

  handler = synth.matchHandler2('/employee/maiah/department/1');
  print('"/employee/:name/department/:id" =? "${handler.path}"');
}