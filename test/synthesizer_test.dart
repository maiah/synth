import '../lib/synth.dart';

main() {
  bool isMatched = Router.matchPathToRoute('GET', '/', 'GET', '/');
  asserts(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/hey', 'GET', '/hey');
  asserts(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/person', 'GET', '/person');
  asserts(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/person/:name', 'GET', '/person/maiah');
  asserts(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/employee/:name/department/:id', 'GET', '/employee/maiah/department/3/');
  asserts(true, isMatched);

  isMatched = Router.matchPathToRoute('GET', '/book/:id', 'GET', '/book');
  asserts(false, isMatched);
}

asserts(var expected, var result) {
  if (expected != result)
    throw new Exception('$expected != $result');
}