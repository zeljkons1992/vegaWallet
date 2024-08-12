import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/usecase/use_case.dart';
import 'package:vegawallet/core/services/location_foreground_service.dart';
import 'package:vegawallet/features/profile/domain/enums/location_permission_response.dart';

@Injectable()
class StartLocationTrackingUseCase extends UseCase<LocationPermissionResponse, String> {
  final LocationForegroundService _locationForegroundService;

  StartLocationTrackingUseCase(this._locationForegroundService);

  @override
  Future<LocationPermissionResponse> call({String? params}) {
    return _locationForegroundService.startLocationTracking(params!);
  }
}
