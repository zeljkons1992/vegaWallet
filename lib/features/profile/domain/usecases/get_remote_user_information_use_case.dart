import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/usecase/use_case.dart';

@Injectable()
class GetRemoteUserInformationUseCase extends UseCase<DataState, String>{

  final ProfileRepository _profileRepository;

  GetRemoteUserInformationUseCase(this._profileRepository);

  @override
  Future<DataState> call({ String? params}) async{
    return await _profileRepository.getRemoteUserInformation(params!);
  }

}