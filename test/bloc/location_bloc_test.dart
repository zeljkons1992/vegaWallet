import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/services/connectivity_service.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';
import 'package:vegawallet/features/stores/domain/usecases/get_picked_store_use_case.dart';
import 'package:vegawallet/features/stores/domain/usecases/open_native_navigation_use_case.dart';
import 'package:vegawallet/features/stores/presentation/bloc/location_bloc/location_bloc.dart';

@GenerateMocks([GetPickedStoreUseCase, OpenNativeNavigationUseCase, ConnectivityService])
import 'location_bloc_test.mocks.dart';

void main() {
  late LocationBloc locationBloc;
  late MockGetPickedStoreUseCase mockGetPickedStoreUseCase;
  late MockOpenNativeNavigationUseCase mockOpenNativeNavigationUseCase;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockGetPickedStoreUseCase = MockGetPickedStoreUseCase();
    mockOpenNativeNavigationUseCase = MockOpenNativeNavigationUseCase();
    mockConnectivityService = MockConnectivityService();

    when(mockConnectivityService.listenToConnectivity())
        .thenAnswer((_) => Stream.value(true));

    locationBloc = LocationBloc(
      mockGetPickedStoreUseCase,
      mockOpenNativeNavigationUseCase,
      mockConnectivityService,
    );
  });

  tearDown(() {
    locationBloc.close();
  });

  group('LocationBloc Tests', () {
    blocTest<LocationBloc, LocationState>(
      'emits [FetchStoreLocationSuccessState] when UpdateStoreLocation is added and there is connectivity',
      build: () {
        when(mockConnectivityService.checkConnectivity())
            .thenAnswer((_) async => true);
        when(mockGetPickedStoreUseCase(params: anyNamed('params')))
            .thenAnswer((_) async => DataState.success(const PositionSimple(latitude: 0.0, longitude: 0.0)));

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
        when(mockConnectivityService.checkConnectivity())
            .thenAnswer((_) async => true);
        when(mockGetPickedStoreUseCase(params: anyNamed('params')))
            .thenAnswer((_) async => DataState.error('Error'));

        return locationBloc;
      },
      act: (bloc) => bloc.add(UpdateStoreLocation('New York')),
      expect: () => [
        const FetchStoreLocationUnsuccessfullyState(),
      ],
    );

    blocTest<LocationBloc, LocationState>(
      'emits [OpenNavigationToAddressUnsuccessful] when OpenNavigationToAddress is added and use case fails',
      build: () {
        when(mockOpenNativeNavigationUseCase(params: anyNamed('params')))
            .thenAnswer((_) async => DataState.error('Error'));

        return locationBloc;
      },
      act: (bloc) => bloc.add(OpenNavigationToAddress('123 Main St')),
      expect: () => [
        OpenNavigationToAddressUnsuccessful(),
      ],
    );

  });
}
