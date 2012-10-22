// Utils
part of synth;

String _removeLastForwardSlashFromPath(String path) {
  return path.length > 1 && path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}