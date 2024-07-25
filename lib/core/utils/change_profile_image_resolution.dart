String updateImageSize(String url, int newSize) {
  final RegExp regex = RegExp(r"=s(\d+)-c");
  final String newSizeString = "=s$newSize-c";
  return url.replaceAll(regex, newSizeString);
}