import 'package:flutter/material.dart';

import 'progress_painter.dart';

class CircularProgress extends StatefulWidget {
  final Color circleColour;
  final double percentage;
  final double strokeWidth;
  final Duration animationDurationSpeed;

  const CircularProgress({
    Key? key,
    required this.circleColour,
    required this.percentage,
    this.strokeWidth = 4,
    this.animationDurationSpeed = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _curve;
  Tween<double>? _valueTween;
  ColorTween? _colourTween;

  @override
  void initState() {
    super.initState();

    _valueTween = Tween<double>(begin: 0, end: widget.percentage);

    _controller = AnimationController(
      duration: widget.animationDurationSpeed,
      vsync: this,
    );

    _controller!.forward();

    _curve = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant CircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.percentage == oldWidget.percentage) return;

    _colourTween =
        ColorTween(begin: oldWidget.circleColour, end: widget.circleColour);

    double beginPercentage = _valueTween!.evaluate(_controller!);

    _valueTween = Tween<double>(begin: beginPercentage, end: widget.percentage);

    _controller!
      ..value = 0
      ..forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      child: Container(),
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          child: child,
          foregroundPainter: ProgressPainter(
            percentage: _valueTween!.evaluate(_controller!),
            circleColour:
                _colourTween?.evaluate(_curve!) ?? widget.circleColour,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}
