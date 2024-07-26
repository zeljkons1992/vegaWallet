import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/connectivity_service.dart';

part 'map_event.dart';
part 'map_state.dart';

@Injectable()
class MapBloc extends Bloc<MapEvent, MapState> {
  final ConnectivityService _connectivityService;
  late StreamSubscription<bool> _connectivitySubscription;

  MapBloc(this._connectivityService) : super(MapInitial()) {

    on<SaveMyLocation>(_onSaveMyLocation);
    on<ConnectionLost>(_onConnectionLost);
    on<ConnectionRegained>(_onConnectionRegained);
    _initConnectivitySubscription();
  }

  FutureOr<void> _onSaveMyLocation(SaveMyLocation event, Emitter<MapState> emit) {
    print("do something");
  }

  void _initConnectivitySubscription() {
    final connectivityStream = _connectivityService.listenToConnectivity();
    _connectivitySubscription = connectivityStream.listen((hasInternet) async {
      if (hasInternet) {
        add(ConnectionRegained());
      } else {
        add(ConnectionLost());
      }
    });
  }

  Future<void> _onConnectionLost(ConnectionLost event, Emitter<MapState> emit) async {
    emit(NoInternetConnection());
  }

  FutureOr<void> _onConnectionRegained(ConnectionRegained event, Emitter<MapState> emit) {
    emit(MapInitial());
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
