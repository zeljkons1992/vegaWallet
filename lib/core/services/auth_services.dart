import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        return false;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Future<bool> signOut() async {
    try{
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      return true;
    }catch(e){
      return false;
    }
  }

}
