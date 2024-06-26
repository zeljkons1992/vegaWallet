// ignore_for_file: constant_identifier_names
enum CacheType {
  NEVER,
  ALWAYS,
  REFRESH,
  CLEAR,
  EXPIRES,
}

class CachePolicy {
  final CacheType type;
  final Duration expires;

  CachePolicy({this.type = CacheType.ALWAYS, this.expires = Duration.zero});
}
