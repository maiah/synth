synth
=====

Simple, minimal, and efficient [Dart](http://dartlang.org) web developement framework.

Prerequisite: [Dart](http://www.dartlang.org/downloads.html) installed in your machine.

Step 1: Create a project using [Dart IDE](http://www.dartlang.org/docs/editor/) or commandline. Instructions below is thru commandline.
```sh
$ mkdir hello
$ cd hello
```

Step 2: Inside `hello` directory create a `pubspec.yaml` file with the contents below.
```
name: hello
dependencies:
  synth:
    git: git://github.com/maiah/synth.git
```

Step 3: Inside `hello` directory execute `pub install`. This will create `packages` folder and download the `synth` library.
```sh
$ pub install
```

Step 4: Create `hello_server.dart` file inside `hello` folder and import `synth.dart` library in that file.
```dart
#import('package:synth/synth.dart');
```

Step 5: And also in this file create `main` method and define your routes and start the `HTTP` server.
```dart
main () {
  route('GET', '/', (req, res)
    => res.write('Hello, World!'));

  start(7000);
  print('Listening on port 7000');
}
```

Step 6: Run your Dart program using Dart IDE or commandline. Instructions below is thru commandline.
```sh
$ dart hello_server.dart
```

Step 7: Open your web browser and go to `http://localhost:7000` and the message below will be shown.
```
Hello, World!
```