import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

class KPerspectiveToggle extends StatelessWidget {
  final Function() onClick;
  final Widget child;
  final bool isSelected;

  Color get activeColor => KStyles.colorButton;

  Color get lightActiveColor => this.activeColor.withOpacity(0.05);

  const KPerspectiveToggle(
      {required this.child, required this.onClick, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final body = InkWell(
      onTap: this.onClick,
      splashColor: this.lightActiveColor,
      highlightColor: this.lightActiveColor,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: this.isSelected ? this.lightActiveColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: this.isSelected ? this.activeColor : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: Center(child: this.child),
      ),
    );

    return body;
  }
}
