import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/services/connectivity_service.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';
import 'package:vegawallet/features/stores/domain/usecases/get_picked_store_use_case.dart';
import 'package:vegawallet/features/stores/domain/usecases/open_native_navigation_use_case.dart';
import 'package:vegawallet/features/stores/presentation/bloc/location_bloc/location_bloc.dart';

// Mock classes
class MockGetPickedStoreUseCase extends Mock implements GetPickedStoreUseCase {}
class MockOpenNativeNavigationUseCase extends Mock implements OpenNativeNavigationUseCase {}
class MockConnectivityService extends Mock implements ConnectivityService {}

// Fallback value classes
class FakeUpdateStoreLocation extends Fake implements UpdateStoreLocation {}
class FakeOpenNavigationToAddress extends Fake implements OpenNavigationToAddress {}

void main() {
  late LocationBloc locationBloc;
  late MockGetPickedStoreUseCase mockGetPickedStoreUseCase;
  late MockOpenNativeNavigationUseCase mockOpenNativeNavigationUseCase;
  late MockConnectivityService mockConnectivityService;

  setUpAll(() {
    registerFallbackValue(FakeUpdateStoreLocation());
    registerFallbackValue(FakeOpenNavigationToAddress());
  });

  setUp(() {
    mockGetPickedStoreUseCase = MockGetPickedStoreUseCase();
    mockOpenNativeNavigationUseCase = MockOpenNativeNavigationUseCase();
    mockConnectivityService = MockConnectivityService();

    when(() => mockConnectivityService.listenToConnectivity())
        .thenAnswer((_) => Stream.value(true));
    when(() => mockConnectivityService.checkConnectivity())
        .thenAnswer((_) async => true);
  });

  tearDown(() {
    locationBloc.close();
  });

  group('LocationBloc Tests', () {
    blocTest<LocationBloc, LocationState>(
      'emits [FetchStoreLocationSuccessState] when UpdateStoreLocation is added and there is connectivity',
      build: () {
        when(() => mockGetPickedStoreUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.success(const PositionSimple(latitude: 0.0, longitude: 0.0)));

        locationBloc = LocationBloc(
          mockGetPickedStoreUseCase,
          mockOpenNativeNavigationUseCase,
          mockConnectivityService,
        );

        return locationBloc;
      },
      act: (bloc) => bloc.add(UpdateStoreLocation('New York')),
      expect: () => [
        const FetchStoreLocationSuccessState(PositionSimple(latitude: 0.0, longitude: 0.0)),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [FetchStoreLocationUnsuccessfullyState] when UpdateStoreLocation is added and use case fails',
      build: () {
        when(() => mockGetPickedStoreUseCase(params: any(named: 'params')))
            .thenAnswer((_) async => DataState.error('Error'));

        locationBloc = LocationBloc(
          mockGetPickedStoreUseCase,
          mockOpenNativeNavigationUseCase,
          mockConnectivityService,
        );

        return locationBloc;
      },
      act: (bloc) => bloc.add(UpdateStoreLocation('New York')),
      expect: () => [
        const FetchStoreLocationUnsuccessfullyState(),
      ],
    );
  });
}
