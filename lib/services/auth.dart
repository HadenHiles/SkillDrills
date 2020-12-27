import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_strength/password_strength.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<GoogleSignInAccount> signInWithGoogle() async {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  // Obtain the auth details from the request
  return _googleSignIn.signIn();
}

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final AccessToken result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.token);

  // Once signed in, return the UserCredential
  return await auth.signInWithCredential(facebookAuthCredential);
}

Future<void> signOut() async {
  await auth.signOut();
}

bool emailVerified() {
  auth.currentUser.reload();
  return auth.currentUser.emailVerified;
}

bool validEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

bool validPassword(String pass) {
  return estimatePasswordStrength(pass) > 0.7;
}
