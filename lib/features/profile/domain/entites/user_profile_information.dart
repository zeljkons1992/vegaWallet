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

  const UserProfileInformation({
    required this.uid,
    required this.nameAndSurname,
    required this.email,
    this.phoneNumber,
    required this.profileImage,
    required this.dateTime,
    this.position
  });

  @override
  List<Object?> get props => [uid,nameAndSurname, email, phoneNumber, profileImage, dateTime,  position];
}
