import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAuthentication {
  Future<void> sharedPrefSetTrue() async {
    final _preferences = await SharedPreferences.getInstance();

    await _preferences.setBool('fld${_auth.currentUser.uid}', true);
    print('FieldsUploded set true');
  }

  Future<void> firstPrefSetTrue() async {
    final _preferences = await SharedPreferences.getInstance();

    await _preferences.setBool('first${_auth.currentUser.uid}', true);
    print('FirstTime set true');
  }

  Future<void> inviterPrefSetTrue() async {
    final _preferences = await SharedPreferences.getInstance();

    await _preferences.setBool('inv${_auth.currentUser.uid}', true);
    print('InviterEmailUploaded set true');
  }

  Future<bool> fieldUploader() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print(
        'fileduploadervalue: ${_pref.getBool('fld${_auth.currentUser.uid}')}');
    return _pref.getBool('fld${_auth.currentUser.uid}');
  }

  Future<bool> inviterEmailUploader() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool('inv${_auth.currentUser.uid}');
  }

  final _auth = FirebaseAuth.instance;
  Future<User> emailLogIn(String email, String password) async {
    final credentials = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return credentials.user;
  }

  bool emailVerified() {
    final credentials = _auth.currentUser.emailVerified;
    return credentials;
  }

  String getUID() {
    final credentials = _auth.currentUser.uid;
    return credentials;
  }

  String getEmail() {
    final credentials = _auth.currentUser.email;
    return credentials;
  }

  Future<User> register(String email, String password) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credentials.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Stream<User> authStatus() {
    return _auth.authStateChanges();
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } else {
      return null;
    }
  }
}
