part of synth;


class Render {
  
  const PATH_VIEW = '/views/';
  const PATH_LAYOUT = '/views/layout/';
  
  // the passed in template
  String template;
  
  // returns the root path of the app
  String get _basePath {
    
    var script = new File(new Options().script);
    var directory = script.directorySync();
    
    return "${directory.path}/";
  }
  
  Render( String this.template );
  
  String render() {

    return 'render template: ${this._basePath}${this.template}';
  }
  
}
