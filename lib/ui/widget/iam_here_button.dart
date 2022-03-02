import 'package:flutter/material.dart';

class IamHereButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool visible;

  const IamHereButton(
      {Key? key, required this.onPressed, required this.visible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: this.visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: IconButton(
        onPressed: this.onPressed,
        icon: Icon(
          Icons.my_location_outlined,
          size: 48,
          color: Colors.red,
        ),
      ),
    );
  }
}
