import 'package:equatable/equatable.dart';
import 'package:vegawallet/features/stores/domain/entities/position.dart';

class UserProfileInformation extends Equatable {
  final String uid;
  final String nameAndSurname;
  final String email;
  final String? phoneNumber;
  final String profileImage;
  final String dateTime;
  final PositionSimple? position;
  final bool? isLocationOn;

  const UserProfileInformation({
    required this.uid,
    required this.nameAndSurname,
    required this.email,
    this.phoneNumber,
    required this.profileImage,
    required this.dateTime,
    this.position,
    this.isLocationOn,
  });

  UserProfileInformation copyWith({
    String? uid,
    String? nameAndSurname,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? dateTime,
    PositionSimple? position,
    bool? isLocationOn,
  }) {
    return UserProfileInformation(
      uid: uid ?? this.uid,
      nameAndSurname: nameAndSurname ?? this.nameAndSurname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      dateTime: dateTime ?? this.dateTime,
      position: position ?? this.position,
      isLocationOn: isLocationOn ?? this.isLocationOn,
    );
  }

  @override
  List<Object?> get props => [uid,nameAndSurname, email, phoneNumber, profileImage, dateTime,  position, isLocationOn];
}
