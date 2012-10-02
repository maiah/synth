![synth!](https://raw.github.com/maiah/synth/master/resources/synth_logo.png)

synth
=====

Simple, minimal, and efficient [Dart](http://dartlang.org) web developement framework.

Prerequisite: [Dart](http://www.dartlang.org/downloads.html) and [Git](https://help.github.com/articles/set-up-git) installed in your machine.

Basic usage
===========

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

Step 7: Open your web browser and go to [http://localhost:7000](http://localhost:7000) and the message below will be shown.
```
Hello, World!
```

Adding middleware
=================

Adding middleware is very simple. It's like providing a HTTP request handler. But you have to register your middleware thru the `use` method.

Unlike request handler, middlewares must have a `bool` return value. Take a look at the typedef Middleware signature below:
```dart
typedef bool Middleware(Request req, Response res);
```

For example you want to add a middleware that will log the request path each time a request is processed.
```dart
use((req, res) {
  print('Request path is ${req.path}');
  return true;
});
```

The code above will register the middleware closure you created and will execute everytime a request is processed.

### Adding middleware into a specific route

Adding middleware into a speficif route is done thru `route` method. The middleware method signature is the same. Add it before the request handler like below.
```dart
...
bool someMiddleware(req, res) {
  print('Some middleware here.');
  return true;
}
...

route('GET', '/', someMiddleware, (req, res) {
  res.write('A route with middleware.');
});
```

The code above will register and execute the middleware only for this specific route.

### Built-in middlewares

* `logPath` - Used for logging the Request path and its query parameters.
* `reqContent` - Used to gather Request POST data and populate `Request`#`dataMap` property which can be accessed by user-defined request handlers and other middlewares.

Synth Robot Boy art by [KabisCube](http://kabiscube.deviantart.com/) `kabiscube@yahoo.com`