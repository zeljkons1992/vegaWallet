import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';
import '../../../domain/usecases/get_current_location_use_case.dart';
import '../../../domain/usecases/get_picked_store_use_case.dart';
import '../../../domain/usecases/open_native_navigation_use_case.dart';

part 'location_event.dart';
part 'location_state.dart';

@Injectable()
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetPickedStoreUseCase _getPickedStoreUseCase;
  final OpenNativeNavigationUseCase _openNativeNavigationUseCase;
  final _navigationStreamController = StreamController<DataState<PositionSimple>>();

  LocationBloc(
      this._getCurrentLocationUseCase,
      this._getPickedStoreUseCase,
      this._openNativeNavigationUseCase,
      ) : super(LocationInitial()) {
    on<GetLocation>(_onGetLocation);
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<OpenLocationSettings>(_onOpenLocationSettings);
    on<UpdateStoreLocation>(_onUpdateStoreLocation);
    on<OpenNavigationToAddress>(_onOpenNativeNavigation);
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
    final result = await _getPickedStoreUseCase(params: event.city);
    if (result.status == DataStateStatus.success) {
      emit(StoreLocationUpdatedSuccess(result.data));
    } else {
      emit(StoreLocationUpdatedUnsuccessful(result.message ?? 'Failed to update store location'));
    }
  }

  Future<void> _onOpenNativeNavigation(OpenNavigationToAddress event, Emitter<LocationState> emit) async {
    final result = await _openNativeNavigationUseCase(params: event.address);
    if(result.status==DataStateStatus.success){
      _navigationStreamController.sink.add(result);
    }else{
      emit(OpenNavigationToAddressUnsuccessful());
    }
  }

  @override
  Future<void> close() {
    _navigationStreamController.close();
    return super.close();
  }
}