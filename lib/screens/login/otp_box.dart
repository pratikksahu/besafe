import 'package:flutter/material.dart';

class OtpBox extends StatefulWidget {

  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> with TickerProviderStateMixin {
  Function superLogger;
  String otp;
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
          onChanged: (otp) {
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
