import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/data/repository/location_repository_impl.dart';
import 'package:vegawallet/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class MockLocationService extends Mock implements LocationService {}


void main() {
  late LocationRepositoryImpl repository;
  late MockLocationService mockLocationService;

  setUp(() {
    mockLocationService = MockLocationService();
    repository = LocationRepositoryImpl(mockLocationService);
  });

  group('LocationRepositoryImpl', () {
    final position = Position(latitude: 37.7749, longitude: -122.4194, timestamp: DateTime(DateTime.december), accuracy: 0.0, altitude: 0.0, altitudeAccuracy: 0.0, heading: 0.0, headingAccuracy: 0.0, speed: 0.0, speedAccuracy: 0.0);


    test('should return current location successfully', () async {
      // Arrange
      when(() => mockLocationService.getCurrentPosition()).thenAnswer((_) async => position);
      final result = await repository.getCurrentLocation();
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(position));
    });

    test('should return error when getting current location fails', () async {
      const errorMessage = 'Location service error';
      when(() => mockLocationService.getCurrentPosition()).thenThrow(Exception(errorMessage));
      final result = await repository.getCurrentLocation();
      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals('Exception: $errorMessage'));
    });
  });
}
