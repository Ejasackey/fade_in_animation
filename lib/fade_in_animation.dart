import 'package:flutter/material.dart';

enum AnimationDirection { upward, downward, rightward, leftward }

enum AnimationType { scale, translate, scaleTranslate }

class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final int delayIndex;
  final int delayFactor;
  final double scaleFactor;
  final int animationDuration;
  AnimationDirection direction;
  AnimationDirection? reverseDirection;
  AnimationType animationType;
  Curve forwardCurve;
  Curve reverseCurve;
  final bool reverse;

  FadeInAnimation({
    super.key,
    required this.child,
    this.delayIndex = 0,
    this.direction = AnimationDirection.upward,
    this.reverse = false,
    this.reverseDirection,
    this.delayFactor = 100,
    this.animationDuration = 750,
    this.animationType = AnimationType.translate,
    this.scaleFactor = .9,
    this.forwardCurve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeOutCubic,
  }) {
    if (reverse && reverseDirection == null) {
      reverseDirection = switch (direction) {
        AnimationDirection.upward => AnimationDirection.downward,
        AnimationDirection.downward => AnimationDirection.upward,
        AnimationDirection.rightward => AnimationDirection.leftward,
        _ => AnimationDirection.rightward
      };
    }
    assert(scaleFactor >= 0 && scaleFactor <= 1,
        'Scale factor must be between 0 and 1');
  }

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> trans;
  late Animation<double> opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration));
    trans = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.reverse ? widget.reverseCurve : widget.forwardCurve));
    opacityAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.reverse ? Curves.easeOutCubic : Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
          Duration(milliseconds: (widget.delayIndex * widget.delayFactor)));
      _controller.forward();
    });
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
      builder: (context, child) {
        return Opacity(
          opacity: widget.reverse
              ? (1 - opacityAnim.value.clamp(0, 1))
              : opacityAnim.value.clamp(0, 1),
          child: Transform.scale(
            scale: widget.animationType == AnimationType.translate
                ? 1
                : widget.reverse
                    ? 1 - ((1 - widget.scaleFactor) * trans.value)
                    : widget.scaleFactor +
                        ((1 - widget.scaleFactor) * trans.value),
            child: Transform.translate(
              // offset: Offset(0, 0),
              offset: widget.animationType == AnimationType.scale
                  ? Offset(0, 0)
                  : getTranslateOffsets(),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }

  //--------------------------------------------------------------------------------------------
  Offset getTranslateOffsets() {
    return widget.reverse
        ? switch (widget.reverseDirection) {
            AnimationDirection.upward => Offset(0, (-30 * trans.value)),
            AnimationDirection.downward => Offset(0, (30 * trans.value)),
            AnimationDirection.rightward => Offset((30 * trans.value), 0),
            _ => Offset((-30 * trans.value), 0)
          }
        : switch (widget.direction) {
            AnimationDirection.upward => Offset(0, (30 - (30 * trans.value))),
            AnimationDirection.downward =>
              Offset(0, (-30 + (30 * trans.value))),
            AnimationDirection.rightward =>
              Offset((-30 + (30 * trans.value)), 0),
            _ => Offset((30 - (30 * trans.value)), 0)
          };
  }
}
