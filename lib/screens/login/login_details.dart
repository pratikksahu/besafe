import 'package:besafe/model/user.dart';
import 'package:besafe/screens/home/home_page.dart';
import 'package:besafe/screens/login/otp_box.dart';
import 'package:besafe/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../adminDashboard.dart';

class LoginDetail extends StatefulWidget {
  @override
  _LoginDetailState createState() => _LoginDetailState();
}

class _LoginDetailState extends State<LoginDetail> {
  String fName, lname, phone, smsCode, fullName;
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

  void setNavigator(User user) async {
    if (user != null) {
      User result = User(uID: user.uID , fullName: fullName);
      print('setNavigator ${result.runtimeType}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            user: result,
          ),
        ),
      );
    }
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
                  // setState(() {
                  //   fullName = fName +' '+lname;
                  //   otpBox = true;
                  // });
                  // Authenticator(otp, setNavigator).phoneVerify(phone);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboard(),));
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
}
