import 'package:flutter/material.dart';

class SwipeRoute extends PageRouteBuilder {
  static const Duration duration = Duration(milliseconds: 800);

  SwipeRoute({required Widget screen, Offset? offset})
      : super(
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (
            BuildContext _,
            Animation<double> animation,
            Animation<double> __,
            Widget child,
          ) {
            final begin = offset ?? Offset(0.0, -1.0);
            final end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
