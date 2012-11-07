part of synth;


class Render {
  
  String template;
  
  Render(String this.template);
  
  String render() {
    return 'render template: ${this.template}';
  }
  
}
