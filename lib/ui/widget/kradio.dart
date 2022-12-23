import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

/// Data Object
class KRadioItem {
  final dynamic id;
  final String value;

  KRadioItem({required this.id, required this.value});
}

/// Controller
class KRadioController extends ValueNotifier<String> {
  KRadioController({String? id}) : super(id ?? "");

  KRadioController.fromValue(String id) : super(id);

  String get id => value;

  set id(String newID) => value = newID;
}

/// Widget
class KRadio extends StatefulWidget {
  static const int DEFAULT_AXIS_CUTOFF = 3;

  final KRadioController controller;
  final int itemCount;
  final KRadioItem Function(int) builder;
  final Axis layoutAxis;
  final bool canDeselect;

  KRadio({
    required this.controller,
    required List<KRadioItem> items,
    Axis? axis,
    this.canDeselect = false,
  })  : this.itemCount = items.length,
        this.builder = ((int index) => items[index]),
        this.layoutAxis = axis ??
            (items.length > DEFAULT_AXIS_CUTOFF
                ? Axis.vertical
                : Axis.horizontal);

  KRadio.builder({
    required this.controller,
    required this.itemCount,
    required this.builder,
    Axis? axis,
    this.canDeselect = false,
  }) : this.layoutAxis = axis ??
            (itemCount > DEFAULT_AXIS_CUTOFF ? Axis.vertical : Axis.horizontal);

  KRadio.fromMap({
    required this.controller,
    required Map<dynamic, String> map,
    Axis? axis,
    this.canDeselect = false,
  })  : this.itemCount = map.length,
        this.builder = ((int index) {
          MapEntry<dynamic, String> entry = map.entries.elementAt(index);
          return KRadioItem(id: entry.key, value: entry.value);
        }),
        this.layoutAxis = axis ??
            (map.length > DEFAULT_AXIS_CUTOFF
                ? Axis.vertical
                : Axis.horizontal);

  @override
  State<StatefulWidget> createState() => _KRadioState();
}

/// State
class _KRadioState extends State<KRadio> {
  bool get isCheckboxLike => widget.itemCount == 1 || widget.canDeselect;

  KRadioItem getItem(int index) => widget.builder(index);

  @override
  void initState() {
    super.initState();

    if (widget.controller.id.isEmpty && !widget.canDeselect)
      widget.controller.id = this.isCheckboxLike ? "" : getItem(0).id;
  }

  void onClick(KRadioItem item) {
    if (item.id != widget.controller.id) {
      setState(() => widget.controller.id = item.id);
    } else {
      if (this.isCheckboxLike) setState(() => widget.controller.id = "");
    }
  }

  List<Widget> buildChildren({bool expanded = false}) =>
      List.generate(widget.itemCount, (e) => e).map((i) {
        KRadioItem item = getItem(i);

        final radioItem = _KRadioItem(
          onSelect: () => onClick(item),
          text: item.value,
          parentAxis: widget.layoutAxis,
          isSelected: item.id == widget.controller.id,
        );

        return expanded ? Expanded(child: Center(child: radioItem)) : radioItem;
      }).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return widget.layoutAxis == Axis.horizontal
        ? Row(children: buildChildren(expanded: true))
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildChildren(),
          );
  }
}

/// List Item Widget
class _KRadioItem extends StatelessWidget {
  final String text;
  final Function() onSelect;
  final Axis parentAxis;
  final bool isSelected;

  _KRadioItem({
    required this.text,
    required this.onSelect,
    required this.parentAxis,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final styleText = Theme.of(context).textTheme.subtitle1!;
    final textView = Text(
      text,
      style: this.isSelected
          ? styleText.copyWith(color: KStyles.colorPrimary)
          : styleText,
    );

    final circle = CircleAvatar(
      maxRadius: 4,
      backgroundColor: this.isSelected
          ? KStyles.colorPrimary
          : this.parentAxis == Axis.vertical
              ? KStyles.lightGrey
              : Colors.transparent,
    );

    final buttonContents = this.parentAxis == Axis.horizontal
        ? Column(children: <Widget>[
            textView,
            SizedBox(height: 2),
            circle,
          ])
        : Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            circle,
            SizedBox(width: 4),
            textView,
          ]);

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: KStyles.blueFaded,
        onTap: this.onSelect,
        child: Container(
          padding: EdgeInsets.only(left: 4, right: 12, top: 4, bottom: 4),
          child: buttonContents,
        ),
      ),
    );

    return button;
  }
}
