import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class KPasscodeInput extends StatefulWidget {
  static const int PASSCODE_LENGTH = 4;

  final TextEditingController passcodeCtrl;
  final Function()? isValidCallback;
  final Stream<bool>? shouldTriggerVerification;

  KPasscodeInput({
    required this.passcodeCtrl,
    this.shouldTriggerVerification,
    this.isValidCallback,
  });

  @override
  State<StatefulWidget> createState() => _KPasscodeInputState();
}

class _KPasscodeInputState extends State<KPasscodeInput>
    with SingleTickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();
  late AnimationController controller;
  late Animation<double> animation;

  StreamSubscription<bool>? streamSubscription;

  String get enteredPasscode => widget.passcodeCtrl.value.text;

  @override
  void initState() {
    super.initState();

    if (widget.shouldTriggerVerification != null)
      streamSubscription = widget.shouldTriggerVerification!
          .listen((isValid) => _showValidation(isValid));

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: _ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve as Animation<double>)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            widget.passcodeCtrl.text = '';
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  _showValidation(bool isValid) {
    if (isValid) {
      // Navigator.maybePop(context).then((pop) => _validationCallback());
    } else {
      controller.forward();
    }
  }

  List<Widget> _buildCircles() {
    final list = <Widget>[];
    final extraSize = animation.value;
    for (int i = 0; i < KPasscodeInput.PASSCODE_LENGTH; i++) {
      list.add(
        Container(
          margin: EdgeInsets.all(8),
          child: _Circle(
            filled: i < enteredPasscode.length,
            extraSize: extraSize,
            borderColor: Theme.of(context).colorScheme.primary,
            fillColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final body = Container(
      margin: const EdgeInsets.only(top: 20),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildCircles(),
      ),
    );

    return body;
  }
}

class _Circle extends StatelessWidget {
  final bool filled;
  final double extraSize;
  final Color borderColor;
  final Color fillColor;
  final double borderWidth;
  final double circleSize;

  _Circle({
    Key? key,
    this.filled = false,
    this.extraSize = 0,
    this.borderColor = Colors.white,
    this.borderWidth = 1,
    this.fillColor = Colors.white,
    this.circleSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: extraSize),
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: filled ? fillColor : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
    );
  }
}

class _ShakeCurve extends Curve {
  @override
  double transform(double t) {
    //t from 0.0 to 1.0
    return sin(t * 2.5 * pi).abs();
  }
}
