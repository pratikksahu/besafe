import 'package:besafe/model/user.dart';
import 'package:besafe/screens/login/login_page.dart';
import 'package:besafe/select_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  BuildContext context;

  AuthService({this.context});

  AuthResult result;

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SelectState();
        } else {
          return LoginPage();
        }
      },
    );
  }

  //SignIN
  signIn(AuthCredential authCreds, User user) async {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Signing In..'),
      ),
    );
    try {
      result = await FirebaseAuth.instance.signInWithCredential(authCreds);
      Firestore firestore = Firestore.instance;
      DocumentSnapshot snapshot =
          await firestore.collection('users').document(result.user.uid).get();

      if (!snapshot.exists) {
        await firestore.collection('users').document(result.user.uid).setData({
          'UID': result.user.uid,
          'Name': user.fullName,
          'Phone': user.phoneNumber,
        }).catchError((onError) => print(onError));
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter correct OTP'),
        ),
      );
    }
  }

  //SignOut
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn with OTP

  signInWithOTP(String smsCode, String vfid, User user) {
    AuthCredential cred =
        PhoneAuthProvider.getCredential(verificationId: vfid, smsCode: smsCode);
    signIn(cred, user);
  }
}
