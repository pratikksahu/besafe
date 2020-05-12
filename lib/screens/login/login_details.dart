import 'package:besafe/screens/home/home_page.dart';
import 'package:besafe/screens/login/otp_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class LoginDetail extends StatefulWidget {
  @override
  _LoginDetailState createState() => _LoginDetailState();
}

class _LoginDetailState extends State<LoginDetail> {
  String fName, lname, phone, verificationID, smsCode;
  AuthResult toMove;
  FirebaseUser result;
  bool otpBox = false;
  String otp;

  Alignment childAlignment = Alignment.bottomCenter;
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          childAlignment =
              visible == true ? Alignment.topCenter : Alignment.bottomCenter;
        });
      },
    );
    super.initState();
  }

  void setOtp(String otpKey) {
    this.otp = otpKey;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: MediaQuery.of(context).size.height * .7,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
      alignment: childAlignment,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * .60,
          width: MediaQuery.of(context).size.width * .85,
          child: Column(
            children: <Widget>[
              //Login text field
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                ),
                width: 300,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                  ),
                  onChanged: (value) {
                    this.fName = value.toString();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                ),
                width: 300,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                  ),
                  onChanged: (value) {
                    this.lname = value.toString();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                  bottom: 20,
                ),
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                  ),
                  onChanged: (value) {
                    this.phone = value.toString();
                  },
                ),
              ),
              otpBox ? OtpBox(logger: setOtp) : SizedBox(),
              RaisedButton(
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 17.0),
                ),
                onPressed: () async {
                  setState(() {
                    otpBox = true;
                  });
                  phoneVerify(phone);
                },
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                height: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/bitlogo.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> phoneVerify(String phone) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final PhoneCodeAutoRetrievalTimeout _autoRetrieve = (String vFID) {
      verificationID = vFID;
    };

    final PhoneCodeSent codeSent = (String vFID, [int forceCodeResend]) {
      void otpLogin() async {
        AuthCredential authCredential = PhoneAuthProvider.getCredential(
          verificationId: vFID,
          smsCode: otp.toString().trim(),
        );
        try {
          toMove = await _auth.signInWithCredential(authCredential);
          result = toMove.user;
        } catch (e) {
          print(e);
        }
        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }

      otpLogin();
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential user) async {
      toMove = await FirebaseAuth.instance.signInWithCredential(user);
      result = toMove.user;
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    };
    final PhoneVerificationFailed verificationFailed = (AuthException exc) {
      print('Error ${exc.message}');
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phone,
          timeout: const Duration(seconds: 0),
          verificationCompleted: verificationSuccess,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: _autoRetrieve);
    } catch (e) {
      print('Error on verify phone number $e');
    }
  }
}
