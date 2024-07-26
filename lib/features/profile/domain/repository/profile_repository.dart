import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';

import '../../../../core/data_state/data_state.dart';

abstract class ProfileRepository {
  Future<DataState<UserProfileInformation>> getUserInformation();
  Future<DataState> updateUserLocation(UserProfileInformation user);

}