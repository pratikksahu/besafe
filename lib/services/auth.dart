import 'package:besafe/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  final Function setter;
  String verificationID, smsCode;
  Authenticator(this.smsCode , this.setter);
  FirebaseUser result;
  AuthResult toMove;

  FirebaseAuth _auth = FirebaseAuth.instance;

  _createUserObj(FirebaseUser user){
    return user != null ? setter(User(uID: user.uid)) : setter(null);
  }

  Future phoneVerify(String phone) async {
    
    final PhoneCodeAutoRetrievalTimeout _autoRetrieve = (String vFID) {
      verificationID = vFID;
      print('TimeOut $verificationID');
    };

    final PhoneCodeSent codeSent = (String vFID, [int forceCodeResend]) async {
      print("code sent to " + phone);

      AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: vFID,
        smsCode: smsCode,
      );
      try {
        print(smsCode);
        toMove = await _auth.signInWithCredential(authCredential);
        result = toMove.user;
        print('Inside codeSent $result');
        _createUserObj(result);
      } catch (e) {
        print('Error in codeSent $e');
      }
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential user) async {
      print('Autoverify' + phone);
      try {
        toMove = await FirebaseAuth.instance.signInWithCredential(user);
        result = toMove.user;
        print('User UID ${result.uid}');
        print('Inside PVC $result');
        _createUserObj(result);
      } catch (e) {
        print(e);
      }
    };
    final PhoneVerificationFailed verificationFailed = (AuthException exc) {
      print('Error ${exc.message}');
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91' + phone,
          timeout: const Duration(seconds: 15),
          verificationCompleted: verificationSuccess,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: _autoRetrieve);
    } catch (e) {
      print('Error on verify phone number $e');
    }
  }
}
