synth
=====

Simple, fast, and efficient [Dart](http://dartlang.org) web developement framework.

Step 1: Import `synth.dart` library.

```dart
#import('synth.dart');
```

Step 2: And in your `main` method define your routes and start the `HTTP` server.

```dart
get('/', (req, res)
  => res.write('Hello, synthesizers!'));

start(7000);
```