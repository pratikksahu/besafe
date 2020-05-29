import 'package:besafe/model/user.dart';
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
  bool otpBox = false;
  String verificationID;

  TextEditingController firstName = TextEditingController(),
      lastName = TextEditingController(),
      phoneNumber = TextEditingController();

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
                  controller: firstName,
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
                  controller: lastName,
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
                  controller: phoneNumber,
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
                ),
              ),
              otpBox ? OtpBox() : SizedBox(),
              Builder(
                builder: (BuildContext loginButtonContext) {
                  return RaisedButton(
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
                      if (firstName.text != null &&
                          lastName.text != null &&
                          phoneNumber.text != null) {
                        User user = new User();
                        user.fullName = firstName.text + ' ' + lastName.text;
                        user.phoneNumber = phoneNumber.text;

                        otpBox
                            ? AuthService(context: loginButtonContext)
                                .signInWithOTP(otp, verificationID, user)
                            : verifyPhone(user, loginButtonContext);
                          
                      }
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  );
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

  Future<void> verifyPhone(User user, BuildContext loginButtonContext) async {
    final PhoneVerificationCompleted verificationComplete =
        (AuthCredential authCred) {
      AuthService(context: loginButtonContext).signIn(authCred, user);
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
      phoneNumber:'+91' + user.phoneNumber,
      timeout: Duration(milliseconds: 60000),
      verificationCompleted: verificationComplete,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
