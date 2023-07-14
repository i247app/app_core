import 'dart:math';

import 'package:flutter/material.dart';

import 'kflip_card.dart';

Widget _fill(Widget child) => Positioned.fill(child: child);

Widget _noop(Widget child) => child;

/// The transition used internally by [KFlipCard]
///
/// You obtain more control by providing your on [Animation]
/// at the cost of built-in methods like [KFlipCardState.flip]
class KFlipCardTransition extends StatefulWidget {
  const KFlipCardTransition({
    super.key,
    required this.front,
    required this.back,
    required this.animation,
    this.direction = Axis.horizontal,
    this.fill = KFill.none,
    this.alignment = Alignment.center,
    this.frontAnimator,
    this.backAnimator,
  });

  /// {@template flip_card.FlipCardTransition.front}
  /// The widget rendered on the front side
  /// {@endtemplate}
  final Widget front;

  /// {@template flip_card.FlipCardTransition.back}
  /// The widget rendered on the front side
  /// {@endtemplate}
  final Widget back;

  /// The [Animation] that controls the flip card
  final Animation<double> animation;

  /// {@template flip_card.FlipCardTransition.direction}
  /// The animation [Axis] of the card
  /// {@endtemplate}
  final Axis direction;

  /// {@template flip_card.FlipCardTransition.fill}
  /// Whether to fill a side of the card relative to the other
  /// {@endtemplate}
  final KFill fill;

  /// {@template flip_card.FlipCardTransition.alignment}
  /// How to align the [front] and [back] in the card
  /// {@endtemplate}
  final Alignment alignment;

  /// The [Animatable] used to animate the front side
  final Animatable<double>? frontAnimator;

  /// The [Animatable] used to animate the back side
  final Animatable<double>? backAnimator;

  /// The default [frontAnimator]
  static final defaultFrontAnimator = TweenSequence(
    [
      TweenSequenceItem<double>(
        tween: Tween(begin: 0.0, end: pi / 2).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(pi / 2),
        weight: 50.0,
      ),
    ],
  );

  /// The default [backAnimator]
  static final defaultBackAnimator = TweenSequence(
    [
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(pi / 2),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: -pi / 2, end: 0.0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50.0,
      ),
    ],
  );

  @override
  State<KFlipCardTransition> createState() => _KFlipCardTransitionState();
}

class _KFlipCardTransitionState extends State<KFlipCardTransition> {
  late KCardSide _currentSide;

  @override
  void initState() {
    super.initState();
    _currentSide = KCardSide.fromAnimationStatus(widget.animation.status);
    widget.animation.addStatusListener(_handleChange);
  }

  @override
  void didUpdateWidget(covariant KFlipCardTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation.removeStatusListener(_handleChange);
      widget.animation.addStatusListener(_handleChange);
      _currentSide = KCardSide.fromAnimationStatus(widget.animation.status);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.animation.removeStatusListener(_handleChange);
  }

  void _handleChange(AnimationStatus status) {
    final newSide = KCardSide.fromAnimationStatus(status);
    if (newSide != _currentSide) {
      setState(() {
        _currentSide = newSide;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final frontPositioning = widget.fill == KFill.front ? _fill : _noop;
    final backPositioning = widget.fill == KFill.back ? _fill : _noop;

    return Stack(
      alignment: widget.alignment,
      fit: StackFit.passthrough,
      children: <Widget>[
        frontPositioning(_buildContent(child: widget.front)),
        backPositioning(_buildContent(child: widget.back)),
      ],
    );
  }

  Widget _buildContent({required Widget child}) {
    final isFront = child == widget.front;
    final showingFront = _currentSide == KCardSide.front;

    /// pointer events that would reach the backside of the card should be
    /// ignored
    return IgnorePointer(
      /// absorb the front card when the background is active (!isFront),
      /// absorb the background when the front is active
      ignoring: isFront ? !showingFront : showingFront,
      child: FlipTransition(
        animation: isFront
            ? (widget.frontAnimator ?? KFlipCardTransition.defaultFrontAnimator)
                .animate(widget.animation)
            : (widget.backAnimator ?? KFlipCardTransition.defaultBackAnimator)
                .animate(widget.animation),
        direction: widget.direction,
        child: child,
      ),
    );
  }
}

/// The transition used by each side of the [KFlipCardTransition]
///
/// This applies a rotation [Transform] in the given [direction]
/// where the angle is [Animation.value]
class FlipTransition extends AnimatedWidget {
  const FlipTransition({
    super.key,
    required this.child,
    required this.animation,
    required this.direction,
  }) : super(listenable: animation);

  /// The [Animation] that controls this transition
  final Animation<double> animation;

  /// The widget being animated
  final Widget child;

  /// The direction of the flip
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.001);
    switch (direction) {
      case Axis.horizontal:
        transform.rotateY(animation.value);
        break;
      case Axis.vertical:
        transform.rotateX(animation.value);
        break;
    }

    return Transform(
      transform: transform,
      alignment: FractionalOffset.center,
      filterQuality: FilterQuality.none,
      child: child,
    );
  }
}
