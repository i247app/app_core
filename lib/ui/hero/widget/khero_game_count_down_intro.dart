import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KGameCountDownIntro extends StatefulWidget {
  final Function? onFinish;

  const KGameCountDownIntro({this.onFinish});

  @override
  _KGameCountDownIntroState createState() => _KGameCountDownIntroState();
}

class _KGameCountDownIntroState extends State<KGameCountDownIntro>
    with SingleTickerProviderStateMixin {
  int count = 3;
  Timer? _timer;
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleAnimationController;

  @override
  void initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {
          _scaleAnimationController.reverse();
        } else if (mounted && status == AnimationStatus.dismissed) {}
      });
    _scaleAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _scaleAnimationController, curve: Curves.easeInOutSine));

    _scaleAnimationController.forward();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      ;
      if (count - 1 == 0 && this.widget.onFinish != null) {
        _timer?.cancel();
        this.widget.onFinish!();
      }
      if (mounted && count > 0) {
        _scaleAnimationController.forward();
        this.setState(() {
          count = count - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleAnimationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Text(
                "${count}",
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 200,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 10.0,
                      color: Color.fromARGB(120, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return body;
  }
}
