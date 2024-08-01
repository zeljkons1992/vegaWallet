import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';

abstract class WalletRemoteDataSource{
  Future<List<UserProfileInformation>> fetchUsersCardInformation();
}