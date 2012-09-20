#import('synthesizer.dart');

main() {
  route('GET', '/', (req, res) => res.write('This is root'));
  route('GET', '/hey', (req, res) => res.write('yo'));
  route('GET', '/person', (req, res) => res.write('Hello, there'));
  route('GET', '/person/:name', (req, res) => res.write('Hello, <Name>'));
  route('GET', '/employee/:name/department/:id', (req, res) => res.write('Hello, dept'));

  SynthHandler handler = Router.matchHandler('/');
  print('"/" =? "${handler.path}", handler = ${handler.handler}');

  handler = Router.matchHandler('/hey');
  print('"/hey" =? "${handler.path}", handler = ${handler.handler}');

  handler = Router.matchHandler('/person');
  print('"/person" =? "${handler.path}", handler = ${handler.handler}');

  handler = Router.matchHandler('/person/maiah/');
  print('"/person/:name" =? "${handler.path}", handler = ${handler.handler}');

  handler = Router.matchHandler('/employee/maiah/department/1');
  print('"/employee/:name/department/:id" =? "${handler.path}", handler = ${handler.handler}');
}