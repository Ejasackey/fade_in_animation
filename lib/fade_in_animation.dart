import 'package:flutter/material.dart';

enum AnimationDirection { upward, downward, rightward, leftward }

enum AnimationType { scale, translate, scaleTranslate }

// ignore: must_be_immutable
class FadeInAnimation extends StatefulWidget {
  final Widget child;

  /// Used in conjunction with `delayFactor` to determine how long this widget will wait before animating.
  /// i.e `delayIndex` * `delayFactor` in milliseconds
  final int delayIndex;

  /// used in conjuction with `delayIndex` to define how long this widget will wait before animating.
  /// basically it's the delay step.
  final int delayFactor;

  ///Defines the starting and ending scale of the widget when animation is in forward and reverse mode respectively.
  ///it only works when `animationType` is set to `AnimationType.scale`.
  final double scaleFactor;

  ///Defines the duration of the animation.
  final int animationDuration;

  ///Use this to dictate the direction of the translation when animation is in forward mode.
  ///it does not work when `animationType` is set to `AnimationType.scale`
  final AnimationDirection direction;

  ///Use this to dictate the direction of the translation when animation is in reverse mode.
  ///it does not work when `animationType` is set to `AnimationType.scale`
  AnimationDirection? reverseDirection;

  ///Defines the animation types available
  final AnimationType animationType;

  ///Defines the animation curves used when animation is in forward mode
  final Curve forwardCurve;

  ///Defines the animation curves used when animation is in reverse mode
  final Curve reverseCurve;

  ///Determines whether animation should play in forward or reverse, defauls is set to `false`
  final bool reverse;

  ///Determines whether the child should be animated or not
  ///setting as false is equal to not having the animation wrapper at all
  final bool animate;

  ///Determines the offset of the translation animation.
  ///The child is translated from  `translationOffset` to 0, or otherwise based on the
  ///`direction`
  final double translationOffset;

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
    this.animate = true,
    this.translationOffset = 30,
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

  //--------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return widget.animate
        ? AnimatedBuilder(
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
          )
        : widget.child;
  }

  //--------------------------------------------------------------------------------------------
  Offset getTranslateOffsets() {
    return widget.reverse
        ? switch (widget.reverseDirection) {
            AnimationDirection.upward =>
              Offset(0, (-widget.translationOffset * trans.value)),
            AnimationDirection.downward =>
              Offset(0, (widget.translationOffset * trans.value)),
            AnimationDirection.rightward =>
              Offset((widget.translationOffset * trans.value), 0),
            _ => Offset((-widget.translationOffset * trans.value), 0)
          }
        : switch (widget.direction) {
            AnimationDirection.upward => Offset(
                0,
                (widget.translationOffset -
                    (widget.translationOffset * trans.value))),
            AnimationDirection.downward => Offset(
                0,
                (-widget.translationOffset +
                    (widget.translationOffset * trans.value))),
            AnimationDirection.rightward => Offset(
                (-widget.translationOffset +
                    (widget.translationOffset * trans.value)),
                0),
            _ => Offset(
                (widget.translationOffset -
                    (widget.translationOffset * trans.value)),
                0)
          };
  }
}
