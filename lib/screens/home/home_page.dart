import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user;
  HomePage({this.user});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ${user.phoneNumber}'),
        ),
        body: Center(
          child: FlatButton(
            onPressed: () async {
              await _auth.signOut().then((value) => Navigator.pop(context));
            },
            child: Text('Sign Out'),
          ),
        ),
      ),
    );
  }
}
