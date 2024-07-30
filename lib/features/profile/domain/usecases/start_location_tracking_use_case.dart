import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/core/services/location_foreground_service.dart';

@Injectable()
class StartLocationTrackingUseCase extends UseCase<void, String> {
  final LocationForegroundService _locationForegroundService;

  StartLocationTrackingUseCase(this._locationForegroundService);

  @override
  Future<void> call({String? params}) {
    return _locationForegroundService.startLocationTracking(params!);
  }
}
