import 'package:besafe/login_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.amber, Colors.deepPurple],
              ),
            ),
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
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/health.png',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: LoginDetail(),
                ),
                SizedBox(
                  height: 40.0,
                )
              ],
            ),
          ),
        ));
  }
}
