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
import 'package:synth/synth.dart';
```

Step 5: And also in this file create `main` method and define your routes and start the `HTTP` server.
```dart
main () {
  route('GET', '/', (req, res)
    => res.write('Hello, World!'));

  start(port: 7000);
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

Routing
=======

You can register a route with a path that holds a variable like below.
```dart
route('GET', '/person/:name', (req, res)
  => res.write('Hi there.'));
```

Then you can access this route with [http://localhost:7000/person/maiah](http://localhost:7000/person/maiah) URL.

You can also have multiple variable in a single route path.
```dart
route('GET', '/person/:name/department/:id', (req, res)
  => res.write('Hello there.'));
```

Then you can access this route with [http://localhost:7000/person/maiah/department/557](http://localhost:7000/person/maiah/department/557) URL.

Adding middleware
=================

Adding middleware is very simple. It's like providing a HTTP request handler. But you have to register your middleware thru the `use` method.

Unlike request handler, middlewares has a 3rd parameter `next` that can be executed to call the next middleware in the stack. Take a look at the typedef `Middleware` signature below:
```dart
typedef void Middleware(Request req, Response res, next);
```

For example you want to add a middleware that will log the request path each time a request is processed.
```dart
use((req, res, next) {
  print('Request path is ${req.path}');
  next(); // Executes the next middleware in the stack if any.
});
```

The code above will register the middleware closure you created and will execute everytime a request is processed.

### Adding middleware into a specific route

Adding middleware into a specific route is done thru `route` method. The middleware method signature is the same. Add it before the request handler like below.
```dart
...
var someMiddleware = (req, res, next) {
  print('Some middleware here.');
  next();
}
...

route('GET', '/', someMiddleware, (req, res) {
  res.write('A route with middleware.');
});
```

The code above will register and execute the middleware only for this specific route.

### Built-in middlewares

* [logPath](https://github.com/maiah/synth/wiki/Middleware-logPath) - Used for logging the request path and its query parameters.
* [reqContent](https://github.com/maiah/synth/wiki/Middleware-reqContent) - Used to gather request POST data and populate `Request`#`dataMap` property which can be accessed by user-defined request handlers and other middlewares.
* [reqJsonContent](https://github.com/maiah/synth/wiki/Middleware-reqJsonContent) - Similar to `reqContent`, except it parses JSON POST data and populates `Request`#`dataObj`.

Synth Robot Boy art by [KabisCube](http://kabiscube.deviantart.com/) `kabiscube@yahoo.com`
