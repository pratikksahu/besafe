import 'package:besafe/screens/home/home_page.dart';
import 'package:besafe/screens/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  AuthResult result;
 handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  //SignIN
  signIn(AuthCredential authCreds) async {
    try {
    result = await FirebaseAuth.instance.signInWithCredential(authCreds);
    } catch (e) {
      print('Error : $e');
    }
    print(result);
  }

  //SignOut
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn with OTP

  signInWithOTP(String smsCode, String vfid) {
    AuthCredential cred =
        PhoneAuthProvider.getCredential(verificationId: vfid, smsCode: smsCode);
    signIn(cred);
  }
}
