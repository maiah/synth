#import('../lib/src/synthesizer.dart');

main() {
  bool isMatched = Router.matchPathToRoute('GET', '/', 'GET', '/');
  assert(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/hey', 'GET', '/hey');
  assert(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/person', 'GET', '/person');
  assert(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/person/:name', 'GET', '/person/maiah');
  assert(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/employee/:name/department/:id', 'GET', '/employee/maiah/department/3/');
  assert(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/book/:id', 'GET', '/book');
  assert(false, isMatched);
}

assert(var expected, var result) {
  if (expected != result)
    throw new Exception('$expected != $result');
}