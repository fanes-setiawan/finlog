import 'package:flutter/material.dart';

class RotatingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool repeat; 
  final bool clockwise; 

  const RotatingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.repeat = true,
    this.clockwise = true,
  });

  @override
  State<RotatingWidget> createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: widget.duration);

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
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
      child: widget.child,
      builder: (context, child) {
        double angle = _controller.value * 2 * 3.1415926535;
        if (!widget.clockwise) angle = -angle;
        return Transform.rotate(
          angle: angle,
          child: child,
        );
      },
    );
  }
}
