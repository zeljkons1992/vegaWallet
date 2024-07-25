import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../domain/usecases/get_picked_store_use_case.dart';
import '../../../domain/usecases/open_native_navigation_use_case.dart';

part 'location_event.dart';
part 'location_state.dart';

@Injectable()
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetPickedStoreUseCase _getPickedStoreUseCase;
  final OpenNativeNavigationUseCase _openNativeNavigationUseCase;
  final ConnectivityService _connectivityService;
  final _navigationStreamController = StreamController<DataState<PositionSimple>>();
  late StreamSubscription<bool> _connectivitySubscription;

  String? _lastCity;
  LocationBloc(
      this._getPickedStoreUseCase,
      this._openNativeNavigationUseCase,
      this._connectivityService,
      ) : super(LocationInitial()) {
    on<UpdateStoreLocation>(_onUpdateStoreLocation);
    on<OpenNavigationToAddress>(_onOpenNativeNavigation);
    on<ConnectivityChanged>(_onConnectivityChanged);
    _initConnectivitySubscription();
  }

  StreamSink<void> get successNavigationSink => _navigationStreamController.sink;
  Stream<DataState<PositionSimple>> get navigationStream => _navigationStreamController.stream.asBroadcastStream();

  Future<void> _onGetLocation(GetLocation event, Emitter<LocationState> emit) async {
    final result = await _getCurrentLocationUseCase();
    if (result.status == DataStateStatus.success) {
      emit(LocationLoaded(result.data));
    } else {
      emit(LocationError(result.message ?? 'An unknown error occurred'));
    }
  }

  Future<void> _onRequestLocationPermission(RequestLocationPermission event, Emitter<LocationState> emit) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      add(GetLocation());
    } else if (permission == LocationPermission.deniedForever) {
      emit(LocationPermissionDenied());
    }
  }

  Future<void> _onOpenLocationSettings(OpenLocationSettings event, Emitter<LocationState> emit) async {
    await Geolocator.openLocationSettings();
    add(GetLocation());
  }

  Future<void> _onUpdateStoreLocation(UpdateStoreLocation event, Emitter<LocationState> emit) async {
    _lastCity = event.city;
    if (await _connectivityService.checkConnectivity()) {
      final result = await _getPickedStoreUseCase(params: event.city);
      if (result.status == DataStateStatus.success) {
        emit(FetchStoreLocationSuccessState(result.data));
      } else {
        emit(const FetchStoreLocationUnsuccessfullyState());
      }
    } else {
      emit(NoInternetConnectionState());
    }
  }

  Future<void> _onOpenNativeNavigation(OpenNavigationToAddress event, Emitter<LocationState> emit) async {
    final result = await _openNativeNavigationUseCase(params: event.address);
    if (result.status == DataStateStatus.success) {
      _navigationStreamController.sink.add(result);
    } else {
      emit(OpenNavigationToAddressUnsuccessful());
    }
  }

  Future<void> _onConnectivityChanged(ConnectivityChanged event, Emitter<LocationState> emit) async {
    emit(NoInternetConnectionState());
  }

  void _initConnectivitySubscription() {
    final connectivityStream = _connectivityService.listenToConnectivity();
    _connectivitySubscription = connectivityStream.listen((hasInternet) async {
      if (hasInternet && _lastCity != null) {
        add(UpdateStoreLocation(_lastCity!));
      } else {
        add(ConnectivityChanged());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _navigationStreamController.close();
    return super.close();
  }
}
