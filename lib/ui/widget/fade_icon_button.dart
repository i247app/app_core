import 'package:flutter/material.dart';

class FadeIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool visible;
  final IconData icon;
  final double size;
  final Color color;
  final int rate;

  const FadeIconButton({
    Key? key,
    required this.onPressed,
    required this.visible,
    required this.icon,
    this.size = 24.0,
    this.rate = 500,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: this.visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: this.rate),
      child: IconButton(
        onPressed: this.onPressed,
        icon: Icon(
          this.icon,
          size: this.size,
          color: this.color,
        ),
      ),
    );
  }
}
