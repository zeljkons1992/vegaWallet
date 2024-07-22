import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/core/domain/exceptions/auth_exception_message.dart';

void main() {
  group('AuthExceptionMessage', () {
    test('should create an AuthExceptionMessage with the correct cause', () {
      const cause = 'An error occurred';
      final exception = AuthExceptionMessage(cause);

      expect(exception.cause, equals(cause));
    });

    test('should return the cause when calling toString', () {
      const cause = 'An error occurred';
      final exception = AuthExceptionMessage(cause);

      expect(exception.toString(), equals(cause));
    });
  });
}
