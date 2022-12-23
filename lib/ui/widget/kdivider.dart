import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KDivider extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  KDivider({this.margin});

  factory KDivider.marginless() => KDivider(margin: EdgeInsets.zero);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin ?? EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      width: double.infinity,
      height: 1,
      color: Theme.of(context).dividerTheme.color,
    );
  }
}
