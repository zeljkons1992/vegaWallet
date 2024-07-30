import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/core/services/location_foreground_service.dart';

@Injectable()
class StopLocationTrackingUseCase extends UseCase<void, void> {
  final LocationForegroundService _locationForegroundService;

  StopLocationTrackingUseCase(this._locationForegroundService);

  @override
  Future<void> call({void params}) {
    return _locationForegroundService.stopLocationTracking();
  }
}
