import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KProfileInput extends StatelessWidget {
  final TextEditingController? controller;
  final String heading;
  final double? headingWidth;
  final String? hintText;
  final bool isRequired;
  final bool? autoFocus;
  final bool? readOnly;
  final bool? showCursor;
  final VoidCallback? onTap;
  final Widget? customChild;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  KProfileInput({
    required this.heading,
    this.headingWidth,
    this.controller,
    this.hintText,
    this.customChild,
    this.prefixIcon,
    this.keyboardType,
    this.autoFocus,
    this.readOnly,
    this.showCursor,
    this.onChanged,
    this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputChild = this.customChild ??
        TextFormField(
          keyboardType: keyboardType,
          onChanged: this.onChanged,
          controller: this.controller,
          autofocus: this.autoFocus ?? false,
          readOnly: this.readOnly ?? false,
          showCursor: this.showCursor ?? true,
          onTap: this.onTap,
          decoration: InputDecoration(
            hintText: this.hintText,
          ),
          validator: this.isRequired
              ? ((z) => z != null && z.isEmpty ? "Field required" : null)
              : null,
        );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: this.headingWidth ?? 58,
              child: Text(
                this.heading,
                style: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: inputChild)
          ],
        ),
      ),
    );
  }
}
