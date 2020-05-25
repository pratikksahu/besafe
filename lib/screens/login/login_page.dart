import 'package:besafe/screens/login/login_form.dart';
import 'package:flutter/material.dart';

import '../../circle_scale.dart';

class LoginPage extends StatelessWidget {
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        color: Color.fromARGB(255, 249, 250, 247),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                'BeSafe',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
            CircleScale(),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
