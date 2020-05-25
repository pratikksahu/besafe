import 'package:besafe/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loaded = false;
  FirebaseUser result;

  Future setUser() async{
    result =  await FirebaseAuth.instance.currentUser();
  }
  @override
  void initState() {
    if(result != null){
      loaded = true;
    }
    else{
      loaded = false;
    }
    super.initState();
  }

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
                    await AuthService().signOut();
                    Navigator.of(context).pop(true);
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
        home: loaded
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Welcome ${result.phoneNumber}'),
                ),
                body: Center(
                  child: FlatButton(
                    onPressed: () async {
                      await AuthService()
                          .signOut()
                          .then((value) => Navigator.pop(context));
                    },
                    child: Text('Sign Out'),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
