synth
=====

Simple, minimal, and efficient [Dart](http://dartlang.org) web developement framework.

Note: This is still a work in progress.

Step 1: Import `synth.dart` library.

```dart
#import('synth.dart');
```

Step 2: And in your `main` method define your routes and start the `HTTP` server.

```dart
route('GET', '/', (req, res)
  => res.write('Hello, World!'));

start(7000);
```

See [Getting Stared](https://github.com/maiah/synth/wiki/Getting-Stared) wiki page for more info.