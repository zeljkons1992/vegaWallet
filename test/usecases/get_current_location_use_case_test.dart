import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/usecases/get_current_location_use_case.dart';
import 'package:vegawallet/features/stores/domain/repository/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late GetCurrentLocationUseCase useCase;
  late MockLocationRepository mockLocationRepository;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    useCase = GetCurrentLocationUseCase(mockLocationRepository);
  });

  group('GetCurrentLocationUseCase', () {
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

    test('should return current location successfully', () async {
      // Arrange
      when(() => mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => DataState.success(position));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(position));
      verify(() => mockLocationRepository.getCurrentLocation()).called(1);
    });

  });
}
