import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class KSimpleDropdownItem {
  final int id;

  final Widget child;

  KSimpleDropdownItem({required this.id, required this.child});
}

class KSimpleDropdown extends StatefulWidget {
  static const double DEFAULT_ITEM_SIZE = 48;

  final List<KSimpleDropdownItem> items;
  final void Function(int id) onSelect;
  final int? initialValueID;

  final BoxDecoration? decoration;
  final double itemSize;

  KSimpleDropdown({
    required this.items,
    required this.onSelect,
    this.initialValueID,
    this.decoration,
    this.itemSize = DEFAULT_ITEM_SIZE,
  });

  @override
  State<StatefulWidget> createState() => _KSimpleDropdownState();
}

class _KSimpleDropdownState extends State<KSimpleDropdown>
    with SingleTickerProviderStateMixin {
  AnimationController? menuAnimController;
  Animation<double>? menuAnimation;
  KSimpleDropdownItem? selectedItem;

  bool isShowing = false;

  @override
  void initState() {
    super.initState();

    selectedItem = widget.items
            .firstWhereOrNull((item) => item.id == widget.initialValueID) ??
        widget.items.first;

    setupAnimation();
  }

  void setupAnimation() {
    menuAnimController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    menuAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: menuAnimController!,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    menuAnimController!.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() => isShowing = !isShowing);
    if (isShowing)
      menuAnimController!.forward();
    else
      menuAnimController!.reverse();
  }

  void selectItem(KSimpleDropdownItem item) {
    setState(() => this.selectedItem = item);

    widget.onSelect(item.id);

    toggleMenu();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIconButton = _ListItem(
      onClick: toggleMenu,
      size: widget.itemSize,
      child: selectedItem!.child,
    );

    final openMenu = Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.items
          .where((i) => i.id != selectedItem!.id)
          .map(
            (i) => _ListItem(
              size: widget.itemSize,
              child: i.child,
              onClick: () => selectItem(i),
            ),
          )
          .toList(growable: false),
    );

    final menu = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        selectedIconButton,
        Container(
          width: widget.itemSize,
          child: SizeTransition(sizeFactor: menuAnimation!, child: openMenu),
        ),
      ],
    );

    final defaultDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(widget.itemSize),
    );

    return Container(
      decoration: widget.decoration ?? defaultDecoration,
      child: menu,
    );
  }
}

class _ListItem extends StatelessWidget {
  final Widget child;
  final Function() onClick;
  final double size;

  _ListItem({required this.child, required this.onClick, required this.size});

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClick,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      );
}
