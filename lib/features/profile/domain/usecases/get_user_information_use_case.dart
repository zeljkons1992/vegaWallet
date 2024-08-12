import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/usecase/use_case.dart';

@Injectable()
class GetUserInformationUseCase extends UseCase<DataState, void>{

  final ProfileRepository _profileRepository;

  GetUserInformationUseCase(this._profileRepository);

  @override
  Future<DataState> call({void params}) async{
    return await _profileRepository.getUserInformation();
  }

}