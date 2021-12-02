import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingActionMenu extends StatefulWidget {
  final List<Widget> children;

  const FloatingActionMenu({required this.children});

  @override
  _FloatingActionMenuState createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationCtrl;
  late final Animation<Color?> animateColor;
  late final Animation<double> translateBtn;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    animationCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    animateColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: animationCtrl,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.easeIn,
      ),
    ));
    translateBtn = Tween<double>(
      begin: 56,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: animationCtrl,
      curve: Interval(
        0.0,
        0.75,
        curve: Curves.easeIn,
      ),
    ));
  }

  @override
  void dispose() {
    animationCtrl.dispose();
    super.dispose();
  }

  void onAnchorClick() {
    if (!isOpen) {
      animationCtrl.forward();
    } else {
      animationCtrl.reverse();
    }
    isOpen = !isOpen;
  }

  @override
  Widget build(BuildContext context) {
    final anchor = FloatingActionButton(
      backgroundColor: animateColor.value,
      onPressed: onAnchorClick,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        color: Colors.white,
        progress: Tween<double>(begin: 0.0, end: 1.0).animate(animationCtrl),
      ),
    );

    final fabChildren = [];
    for (int i = 0; i < widget.children.length; i++) {
      final innerChild = widget.children[widget.children.length - 1 - i];
      final transform = Matrix4.translationValues(
        0.0,
        translateBtn.value * i.toDouble() - 10,
        0.0,
      );
      final w = Transform(
        transform: transform,
        child: Opacity(
          opacity: animationCtrl.value,
          child: Container(child: innerChild),
        ),
      );
      fabChildren.insert(0, w);
    }

    final body = Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ...fabChildren,
        anchor,
      ],
    );

    return body;
  }
}
