import 'package:app_core/helper/kbank_helper.dart';
import 'package:app_core/model/kbank.dart';
import 'package:flutter/material.dart';

class KBankPicker extends StatefulWidget {
  final TextEditingController controller;
  final double height;
  final BoxDecoration? decoration;
  final InputDecoration? inputDecoration;

  KBankPicker({
    required this.controller,
    required this.height,
    this.decoration,
    this.inputDecoration,
  });

  @override
  State<StatefulWidget> createState() => _KBankPickerState();
}

class _KBankPickerState extends State<KBankPicker> {
  List<KBank>? banks;

  @override
  void initState() {
    super.initState();
    loadBanks();
  }

  void loadBanks() async {
    final banks = await KBankHelper.getBanks();
    setState(() {
      this.banks = banks;
    });
    if (banks != null) {
      // Sanitize/default input
      if (widget.controller.text.isEmpty) widget.controller.text = "100";
    }
  }

  void onSelect(String? bank) {
    if (widget.controller.text != bank)
      setState(() => widget.controller.text = bank ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(banks?.length ?? 0, (i) {
      return DropdownMenuItem(
        key: Key("${100 + i}"),
        child: Text(
          "${banks![i].shortName}",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: "${100 + i}",
      );
    });

    return Container(
      width: 70,
      height: widget.height,
      child: (banks?.length ?? 0) > 0
          ? DropdownButtonFormField(
              isExpanded: true,
              style: TextStyle(fontStyle: FontStyle.italic),
              value: widget.controller.text,
              items: items,
              decoration: widget.inputDecoration,
              onChanged: onSelect,
            )
          : Container(),
    );
  }
}
