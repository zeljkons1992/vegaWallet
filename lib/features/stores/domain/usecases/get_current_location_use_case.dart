import 'package:injectable/injectable.dart';
import '../repository/location_repository.dart';

@Injectable()
class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Position> call() async {
    return await repository.getCurrentLocation();
  }
}
