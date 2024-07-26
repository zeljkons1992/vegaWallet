
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/domain/exceptions/auth_exception_message.dart';
import 'package:vegawallet/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/services/auth_services.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {

  final AuthService _authServices;
  final FirebaseDatabase _firebaseDatabase;

  AuthRepositoryImpl(this._authServices, this._firebaseDatabase);

  @override
  Future<DataState> loginUserWithGoogle() async {
    try {

      bool result = await _authServices.signInWithGoogle();
      if (result) {
        final currentUser = await _authServices.getCurrentUser();
        final userExists = await _checkIfUserExists(currentUser!);

        if (!userExists) await _addUserToRemoteDb(currentUser);

        return DataState.success();
      } else {
        return DataState.error(TextConst.userCloseDialog);
      }
    } on AuthExceptionMessage catch (e) {
      return DataState.error(e.cause);
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        return DataState.error("no_network");
      } else {
        return DataState.error(e.toString());
      }
    } catch (e) {
      return DataState.error("tech_prob");
    }
  }

  _addUserToRemoteDb(User user) async {
    DatabaseReference usersRef = _firebaseDatabase.ref().child('users');
      final DateFormat formatter = DateFormat('MMMM d, yyyy');
      final String formattedDate = formatter.format(user.metadata.creationTime!);

      await usersRef.child(user.uid).set({
        'nameAndSurname': user.displayName ?? 'Unknown',
        'email': user.email ?? 'Unknown',
        'phoneNumber': user.phoneNumber ?? 'Unknown',
        'profileImage': user.photoURL ?? '',
        'dateTime': formattedDate,
        'position': null,
        'isLocationOn': null,
      });
  }

  Future<bool> _checkIfUserExists(User user) async {

    DatabaseReference usersRef = _firebaseDatabase.ref().child('users');

    DataSnapshot dataSnapshot = await usersRef.child(user.uid).get();
    return dataSnapshot.exists;
  }

  @override
  Future<DataState> logoutUser() async{
    bool isLogoutSuccess = await _authServices.signOut();
    if(isLogoutSuccess){
      return DataState.success();
    }else{
      return DataState.error("Error");
    }
  }

  @override
  Future<DataState> isUserVega() async {
      var result = await _authServices.isUserEmailValid();
      if(result){
        return DataState.success();
      }
      return DataState.error("Korisnicko ime nije Vega");
  }
}
