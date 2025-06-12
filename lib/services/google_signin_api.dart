import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid', 'profile'],
  );

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future logout = _googleSignIn.disconnect();
}

// class GoogleWebSignInApi {
//
//   static final _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'openid', 'profile'],
//   );
//
//   static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
//   static Future logout = _googleSignIn.disconnect();
//
// }
