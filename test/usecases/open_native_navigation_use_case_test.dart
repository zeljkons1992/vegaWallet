import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/usecases/open_native_navigation_use_case.dart';
import 'package:vegawallet/features/stores/domain/repository/location_repository.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late OpenNativeNavigationUseCase useCase;
  late MockLocationRepository mockLocationRepository;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    useCase = OpenNativeNavigationUseCase(mockLocationRepository);
  });

  group('OpenNativeNavigationUseCase', () {
    final simplePosition = PositionSimple(
      latitude: 45.2671,
      longitude: 19.8335,
    );
    const address = 'Maksima Gorkog 9, Novi Sad';

    test('should return picked store location successfully', () async {
      // Arrange
      when(() => mockLocationRepository.getLocationPickedStore(address))
          .thenAnswer((_) async => DataState.success(simplePosition));

      // Act
      final result = await useCase.call(params: address);

      // Assert
      expect(result.status, equals(DataStateStatus.success));
      expect(result.data, equals(simplePosition));
      verify(() => mockLocationRepository.getLocationPickedStore(address)).called(1);
    });

  });
}
