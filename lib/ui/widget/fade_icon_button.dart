import 'package:flutter/material.dart';

class FadeIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final Color? color;
  final int rate;

  FadeIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.size = 24.0,
    this.rate = 1000,
    this.color,
  }) : super(key: key);

  @override
  State<FadeIconButton> createState() => _FadeIconButtonState();
}

class _FadeIconButtonState extends State<FadeIconButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.rate),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: IconButton(
        onPressed: widget.onPressed,
        icon: Icon(
          widget.icon,
          size: widget.size,
          color: widget.color ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
