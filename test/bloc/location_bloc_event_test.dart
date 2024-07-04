import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/features/stores/presentation/bloc/location_bloc/location_bloc.dart';

void main() {
  group('LocationEvent', () {
    test('GetLocation props should be empty', () {
      final event = GetLocation();

      expect(event.props, []);
    });

    test('RequestLocationPermission props should be empty', () {
      final event = RequestLocationPermission();

      expect(event.props, []);
    });

    test('OpenLocationSettings props should be empty', () {
      final event = OpenLocationSettings();

      expect(event.props, []);
    });

    test('UpdateStoreLocation props should contain city', () {
      const city = 'New York';
      final event = UpdateStoreLocation(city);

      expect(event.props, [city]);
    });

    test('OpenNavigationToAddress props should contain address', () {
      const address = '123 Main St';
      final event = OpenNavigationToAddress(address);

      expect(event.props, [address]);
    });

    test('UpdateStoreLocation with same city should be equal', () {
      const city = 'New York';
      final event1 = UpdateStoreLocation(city);
      final event2 = UpdateStoreLocation(city);

      expect(event1, event2);
      expect(event1 == event2, isTrue);
    });

    test('UpdateStoreLocation with different city should not be equal', () {
      final event1 = UpdateStoreLocation('New York');
      final event2 = UpdateStoreLocation('Los Angeles');

      expect(event1, isNot(event2));
      expect(event1 == event2, isFalse);
    });

    test('OpenNavigationToAddress with same address should be equal', () {
      const address = '123 Main St';
      final event1 = OpenNavigationToAddress(address);
      final event2 = OpenNavigationToAddress(address);

      expect(event1, event2);
      expect(event1 == event2, isTrue);
    });

    test('OpenNavigationToAddress with different address should not be equal', () {
      final event1 = OpenNavigationToAddress('123 Main St');
      final event2 = OpenNavigationToAddress('456 Elm St');

      expect(event1, isNot(event2));
      expect(event1 == event2, isFalse);
    });
  });
}
