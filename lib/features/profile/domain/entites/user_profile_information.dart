import 'package:equatable/equatable.dart';

class UserProfileInformation extends Equatable {
  final String uid;
  final String nameAndSurname;
  final String email;
  final String? phoneNumber;
  final String profileImage;
  final String dateTime;
  final bool isEpsilon;

  const UserProfileInformation({
    required this.uid,
    required this.nameAndSurname,
    required this.email,
    this.phoneNumber,
    required this.profileImage,
    required this.dateTime,
    required this.isEpsilon
  });

  @override
  List<Object?> get props => [uid,nameAndSurname, email, phoneNumber, profileImage, dateTime,isEpsilon];
}
