import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:vegawallet/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/services/auth_services.dart';
import '../../../../core/utils/change_profile_image_resolution.dart';


@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository{

  final AuthService _authServices;

  const ProfileRepositoryImpl(this._authServices);

  @override
  Future<DataState<UserProfileInformation>> getUserInformation()async {
    try {
      final User? user = await _authServices.getCurrentUser();
      if (user == null) {
        return DataState.error('User not logged in');
      }
      final DateFormat formatter = DateFormat('MMMM d, yyyy');
      final String formattedDate = formatter.format(user.metadata.creationTime!);

      UserProfileInformation userProfileInformation = UserProfileInformation(
        uid: user.uid,
        nameAndSurname: user.displayName!,
        email: user.email!,
        phoneNumber: user.phoneNumber,
        profileImage: updateImageSize(user.photoURL!,400),
        dateTime: formattedDate,
]      );
      return DataState.success(userProfileInformation);
    } catch (e) {
      return DataState.error(e.toString());
    }
  }
}