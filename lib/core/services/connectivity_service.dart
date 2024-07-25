import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  late StreamController<bool> _internetConnectionStreamController;
  late Stream<bool> internetConnectionStream;

  ConnectivityService() {
    _internetConnectionStreamController = StreamController<bool>();
    internetConnectionStream = _internetConnectionStreamController.stream.asBroadcastStream();
  }

  Future<bool> checkConnectivity() async {
    List<ConnectivityResult> connectivityResult =
    await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  Stream<bool> listenToConnectivity() async* {
    bool initialStatus = await checkConnectivity();
    yield initialStatus;
    await for (var results in _connectivity.onConnectivityChanged) {
      if (results.contains(ConnectivityResult.none))  {
        yield false;
      } else if (results.contains(ConnectivityResult.wifi) ) {
        yield true;
      }
      else if (results.contains(ConnectivityResult.mobile)) {
        yield true;
      }
    }
  }
}
