import 'package:besafe/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

String otp = '';

class OtpBox extends StatefulWidget {
  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animator;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animator = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 20,
        ),
        width: 300,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'OTP',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
          ),
          onChanged: (value) {
            otp = value;
          },
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return ScaleTransition(
          // angle: _controller.value * math.pi,
          scale: _animator,
          child: child,
        );
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String fName, lname, phone = '', fullName;
  bool otpBox = false;
  String verificationID;

  Alignment childAlignment = Alignment.bottomCenter;
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      // This helps to push login card up and down
      onChange: (bool visible) {
        setState(() {
          childAlignment =
              visible == true ? Alignment.topCenter : Alignment.bottomCenter;
        });
      },
    );
    super.initState();
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
          height: MediaQuery.of(context).size.height * .55,
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
              otpBox ? OtpBox() : SizedBox(),
              RaisedButton(
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: otpBox
                    ? Text(
                        'Verify',
                        style: TextStyle(fontSize: 17.0),
                      )
                    : Text(
                        'Sign In',
                        style: TextStyle(fontSize: 17.0),
                      ),
                onPressed: () {
                  otpBox
                      ? AuthService().signInWithOTP(otp, verificationID)
                      : verifyPhone(phone);
                },
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                height: MediaQuery.of(context).size.height * .1,
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

  Future<void> verifyPhone(String phone) async {
    final PhoneVerificationCompleted verificationComplete =
        (AuthCredential authCred) {
      AuthService().signIn(authCred);
    };

    final PhoneVerificationFailed verificationFailed = (AuthException exc) {
      print('Error ${exc.message}');
    };

    final PhoneCodeSent codeSent = (String vFID, [int forceResend]) {
      verificationID = vFID;
      setState(() => otpBox = true);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String vFID) {
      verificationID = vFID;
      print('TimeOut $verificationID');
    };

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + phone,
      timeout: Duration(milliseconds: 20000),
      verificationCompleted: verificationComplete,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
