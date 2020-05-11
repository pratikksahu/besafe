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
                      fontWeight: FontWeight.bold,
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
                        Padding(
                          padding: EdgeInsets.only(top: 90),
                          child: Text(
                            'Stay home , stay safe',
                            style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 9,
                  child: LoginDetail(),
                )
              ],
            ),
          ),
        ));
  }
}
