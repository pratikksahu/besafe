import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user;
  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to logout?'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "NO",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.of(context).pop(true);
                    // Navigator.of(context).pop(true);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "YES",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
      ),
    );
  }
}
