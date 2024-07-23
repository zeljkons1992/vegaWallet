import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vegawallet/core/services/i_geo_locator_wrapper.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';
import 'package:vegawallet/features/stores/domain/usecases/get_current_location_use_case.dart';
import 'package:vegawallet/features/stores/domain/usecases/get_picked_store_use_case.dart';
import 'package:vegawallet/features/stores/domain/usecases/open_native_navigation_use_case.dart';
import 'package:vegawallet/features/stores/presentation/bloc/location_bloc/location_bloc.dart';

class MockGeolocatorWrapper extends Mock implements IGeolocatorWrapper {}
class MockGetCurrentLocationUseCase extends Mock implements GetCurrentLocationUseCase {}
class MockOpenNativeNavigationUseCase extends Mock implements OpenNativeNavigationUseCase {}
class MockGetPickedStoreUseCase extends Mock implements GetPickedStoreUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LocationBloc locationBloc;
  late MockGetCurrentLocationUseCase mockGetCurrentLocationUseCase;
  late MockOpenNativeNavigationUseCase mockOpenNativeNavigationUseCase;
  late MockGetPickedStoreUseCase mockGetPickedStoreUseCase;

  setUp(() {
    mockGetCurrentLocationUseCase = MockGetCurrentLocationUseCase();
    mockOpenNativeNavigationUseCase = MockOpenNativeNavigationUseCase();
    mockGetPickedStoreUseCase = MockGetPickedStoreUseCase();
    locationBloc = LocationBloc(
      mockGetCurrentLocationUseCase,
      mockGetPickedStoreUseCase,
      mockOpenNativeNavigationUseCase,
    );
  });

  group('LocationBloc', () {
    final testPosition = Position(
      latitude: 37.42796133580664,
      longitude: -122.085749655962,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 1.0,
      altitudeAccuracy: 1.0,
      heading: 1.0,
      headingAccuracy: 1.0,
      speed: 1.0,
      speedAccuracy: 1.0,
    );

    final testPositionSimple = PositionSimple(latitude: 0.0, longitude: 0.0);

    test('initial state is LocationInitial', () {
      expect(locationBloc.state, equals(LocationInitial()));
    });

    blocTest<LocationBloc, LocationState>(
      'emits [LocationLoaded] when GetLocation is added and data is fetched successfully',
      build: () {
        when(() => mockGetCurrentLocationUseCase())
            .thenAnswer((_) async => DataState.success(testPosition));
        return locationBloc;
      },
      act: (bloc) => bloc.add(GetLocation()),
      expect: () => [
        LocationLoaded(testPosition),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [LocationError] when GetLocation is added and data fetch fails',
      build: () {
        when(() => mockGetCurrentLocationUseCase())
            .thenAnswer((_) async => DataState.error('Failed to fetch location'));
        return locationBloc;
      },
      act: (bloc) => bloc.add(GetLocation()),
      expect: () => [
        LocationError('Failed to fetch location'),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [StoreLocationUpdatedSuccess] when UpdateStoreLocation is added and data is fetched successfully',
      build: () {
        when(() => mockGetPickedStoreUseCase(params: 'city'))
            .thenAnswer((_) async => DataState.success(testPositionSimple));
        return locationBloc;
      },
      act: (bloc) => bloc.add(UpdateStoreLocation('city')),
      expect: () => [
        StoreLocationUpdatedSuccess(testPositionSimple),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [StoreLocationUpdatedUnsuccessful] when UpdateStoreLocation is added and data fetch fails',
      build: () {
        when(() => mockGetPickedStoreUseCase(params: 'city'))
            .thenAnswer((_) async => DataState.error('Failed to update store location'));
        return locationBloc;
      },
      act: (bloc) => bloc.add(UpdateStoreLocation('city')),
      expect: () => [
        StoreLocationUpdatedUnsuccessful('Failed to update store location'),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [OpenNavigationToAddressSuccessful] when OpenNavigationToAddress is added and data is fetched successfully',
      build: () {
        when(() => mockOpenNativeNavigationUseCase(params: 'Novi Sad'))
            .thenAnswer((_) async => DataState.success(testPositionSimple));
        return locationBloc;
      },
      act: (bloc) => bloc.add(OpenNavigationToAddress('Novi Sad')),
      expect: () => [

      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [OpenNavigationToAddressUnsuccessful] when OpenNavigationToAddress is added and data fetch fails',
      build: () {
        when(() => mockOpenNativeNavigationUseCase(params: 'Novi Sad'))
            .thenAnswer((_) async => DataState.error('Failed to open native navigation'));
        return locationBloc;
      },
      act: (bloc) => bloc.add(OpenNavigationToAddress('Novi Sad')),
      expect: () => [
        OpenNavigationToAddressUnsuccessful(),
      ],
    );
  });
}
