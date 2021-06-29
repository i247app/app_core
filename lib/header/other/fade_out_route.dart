import 'package:flutter/material.dart';

class FadeOutRoute extends PageRouteBuilder {
  static const Duration duration = Duration(milliseconds: 800);

  final Widget Function(BuildContext) builder;

  FadeOutRoute({required this.builder})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              builder(context),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: duration,
        );
}
