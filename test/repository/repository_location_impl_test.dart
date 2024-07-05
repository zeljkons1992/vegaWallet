import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/data/repository/location_repository_impl.dart';
import 'package:vegawallet/core/services/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';

class MockLocationService extends Mock implements LocationService {}

void main() {
  late LocationRepositoryImpl repository;
  late MockLocationService mockLocationService;

  setUp(() {
    mockLocationService = MockLocationService();
    repository = LocationRepositoryImpl(mockLocationService);
  });

  group('LocationRepositoryImpl', () {
    final position = Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
    final simplePosition = PositionSimple(
      latitude: 45.2671,
      longitude: 19.8335,
    );

    test('should return current location successfully', () async {
      // Arrange
      when(() => mockLocationService.getCurrentPosition())
          .thenAnswer((_) async => position);

      // Act
      final result = await repository.getCurrentLocation();

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(position));
    });

    test('should return error when getting current location fails', () async {
      const errorMessage = 'Location service error';
      when(() => mockLocationService.getCurrentPosition())
          .thenThrow(Exception(errorMessage));

      final result = await repository.getCurrentLocation();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals('Exception: $errorMessage'));
    });

    test('should return location from address successfully', () async {

      const address = 'Maksmima Gorkog 9, Novi Sad';
      final location = Location(
        latitude: 45.2671,
        longitude: 19.8335,
        timestamp: DateTime(DateTime.december),
      );
      when(() => mockLocationService.getLocationFromAddress(address))
          .thenAnswer((_) async => [location]);

      final result = await repository.getLocationPickedStore(address);

      expect(result.status, equals(DataStateStatus.success));
      expect(result.data?.latitude, equals(simplePosition.latitude));
      expect(result.data?.longitude, equals(simplePosition.longitude));
    });

    test('should return error when getting location from address fails', () async {
      // Arrange
      const address = 'Novi Sad';
      const errorMessage = 'Address not found';

      when(() => mockLocationService.getLocationFromAddress(address))
          .thenThrow(Exception(errorMessage));

      final result = await repository.getLocationPickedStore(address);

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals('Exception: $errorMessage'));
    });
  });
}
