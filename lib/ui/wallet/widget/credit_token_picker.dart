import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kbalance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreditTokenPicker extends StatefulWidget {
  final List<KBalance> balances;
  final Function(KBalance) onSelect;

  const CreditTokenPicker({required this.balances, required this.onSelect});

  @override
  _CreditTokenPickerState createState() => _CreditTokenPickerState();
}

class _CreditTokenPickerState extends State<CreditTokenPicker> {
  @override
  Widget build(BuildContext context) {
    final title = Text(
      'Balances',
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      textAlign: TextAlign.center,
    );

    final body = SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                title,
                SizedBox(height: 20),
                for (int i = 0; i < widget.balances.length; i++) ...<Widget>[
                  (() {
                    final balance = widget.balances[i];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onSelect(balance);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${balance.tokenName}",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "${KUtil.prettyMoney(amount: balance.amount, tokenName: balance.tokenName)}",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).call(),
                  if (i < widget.balances.length - 1) Divider(),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return body;
  }
}
