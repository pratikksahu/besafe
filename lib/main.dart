import 'package:besafe/screens/login/login_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'circle_rotation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
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
            CircleRotate(),
            LoginDetail(),
          ],
        ),
      ),
    ));
  }
}
