import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class LoginDetail extends StatefulWidget {
  @override
  _LoginDetailState createState() => _LoginDetailState();
}

class _LoginDetailState extends State<LoginDetail> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        alignment: childAlignment,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Container(
            height: MediaQuery.of(context).size.height * .6,
            width: MediaQuery.of(context).size.height * .43,
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
                  ),
                ),
                RaisedButton(
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  onPressed: () {},
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                  ),
                  height: 90,
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
      ),
    );
  }
}
