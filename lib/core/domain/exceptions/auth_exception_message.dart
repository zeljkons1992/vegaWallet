class AuthExceptionMessage implements Exception {
  String cause;
  AuthExceptionMessage(this.cause);

  @override
  String toString() => cause;

}