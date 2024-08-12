import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/usecase/use_case.dart';

@Injectable()
class UpdateUserLocationUseCase extends UseCase<DataState, UserProfileInformation> {
  final ProfileRepository repository;

  UpdateUserLocationUseCase({required this.repository});

  @override
  Future<DataState> call({UserProfileInformation? params}) async {
    return await repository.updateUserLocation(params!);
  }
}