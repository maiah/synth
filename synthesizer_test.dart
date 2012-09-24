#import('synthesizer.dart');

main() {
  bool isMatched = Router.matchPathToRoute('GET', '/', 'GET', '/');
  print(true == isMatched);

  isMatched = Router.matchPathToRoute('GET', '/hey', 'GET', '/hey');
  print(true == isMatched);

  isMatched = Router.matchPathToRoute('GET', '/person', 'GET', '/person');
  print(true == isMatched);

  isMatched = Router.matchPathToRoute('GET', '/person/:name', 'GET', '/person/maiah');
  print(true == isMatched);

  isMatched = Router.matchPathToRoute('GET', '/employee/:name/department/:id', 'GET', '/employee/maiah/department/3/');
  print(true == isMatched);

  isMatched = Router.matchPathToRoute('GET', '/book/:id', 'GET', '/book');
  print(false == isMatched);
}