import '../lib/synth.dart';

main() {
  route('GET', '/upload', (req, res) {
    res.write(
        '''
        <!DOCTYPE html>
        <html>
        <body>
        <form enctype="multipart/form-data" action="/upload" method="POST">
        <input type="text" name="username" placeholder="username" /><br />
        <input type="password" name="password" placeholder="Password" /><br />
        <input type="file" name="thefile" /><br />
        <input type="submit" value="Upload" />
        </form>
        </body>
        </html>
        '''
        );
  });

  route('POST', '/upload', (req, res) {
    final List<int> data = new List<int>();

    req.inputStream.onData = () {
      data.addAll(req.inputStream.read());
    };

    req.inputStream.onClosed = () {
      String dataString = new String.fromCharCodes(data);
      List<String> contents = dataString.split('\n');

      String webKitFormBoundary = contents[0];
      String contentDisposition = contents[1];
      String contentType = contents[2];

      List<String> haha = dataString.split(webKitFormBoundary);
      for (String h in haha) {
        print('${haha[1]}');
      }

      String fileBody = '';
      for (int i = 4; i < (contents.length - 2); i++) {
        String content = contents[i];
        if (!content.startsWith(webKitFormBoundary)) {
          fileBody = '$fileBody$content\n';
        }
      }

      res.write(dataString);
      res.outputStream.close();
    };
  });

  start(7000);
  print('Listening on port 7000...');
}
