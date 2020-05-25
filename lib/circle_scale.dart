import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class CircleScale extends StatefulWidget {
  CircleScale({Key key}) : super(key: key);

  @override
  _CircleScaleState createState() => _CircleScaleState();
}

class _CircleScaleState extends State<CircleScale>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animator;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
          scale: _animator,
          child: child,
        );
      },
    );
  }
}
