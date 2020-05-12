import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;

class CircleRotate extends StatefulWidget {
  CircleRotate({Key key}) : super(key: key);

  @override
  _CircleRotateState createState() => _CircleRotateState();
}

class _CircleRotateState extends State<CircleRotate>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animator;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // value: .1,
      lowerBound: .2,
      upperBound: 1,
      duration: const Duration(milliseconds: 2000),
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
        height: 100,
        width: 100,
        child: Image.asset(
          'assets/health.png',
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
