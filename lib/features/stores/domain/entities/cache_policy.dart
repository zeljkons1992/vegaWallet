// ignore_for_file: constant_identifier_names
enum CacheType {
  ALWAYS,
  EXPIRES,
}

class CachePolicy {
  final CacheType type;
  final Duration expires;

  CachePolicy({this.type = CacheType.ALWAYS, this.expires = Duration.zero});
}
