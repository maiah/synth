synth
=====

HTTP synthesizer

1. Import synth.dart

```dart
#import('synth.dart', prefix: 'synth');
```

2. And in your main method define your routes and start the HTTP server

```dart
synth.get('/', (req, res)
  => res.write('Hello, synthesizers!'));

synth.synthesize(7000);
```