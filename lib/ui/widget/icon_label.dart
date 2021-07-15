import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_core/header/kstyles.dart';

class KIconLabel extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final String text;
  final TextOverflow? textOverflow;
  final Color? assetColor;
  final bool circleIcon;
  final TextStyle textStyle;
  final double assetSize;
  final bool isFlexible;

  KIconLabel({
    required this.text,
    this.asset,
    this.icon,
    this.textOverflow,
    this.assetColor,
    this.circleIcon = false,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.grey),
    this.assetSize = 16,
    this.isFlexible = false,
  });

  @override
  Widget build(BuildContext context) {
    final rawIcon = this.asset != null
        ? Image.asset(
            this.asset!,
            height: this.assetSize,
            width: this.assetSize,
            color: this.assetColor,
            fit: BoxFit.contain,
          )
        : Icon(this.icon, size: this.assetSize);

    final image = !this.circleIcon
        ? rawIcon
        : Container(
            width: this.assetSize,
            height: this.assetSize,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: KStyles.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: rawIcon,
          );

    final label = Text(
      this.text,
      overflow: this.textOverflow,
      style: this.textStyle,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        image,
        SizedBox(width: 10),
        this.isFlexible ? Flexible(child: label) : label,
      ],
    );
  }
}
