import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmath_helper.dart';
import 'package:app_core/ui/widget/kcount_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// large banner at top of screens
class KCreditBanner extends StatelessWidget {
  final String amount;
  final String tokenName;

  KCreditBanner({required this.amount, required this.tokenName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FittedBox(
        fit: BoxFit.contain,
        child: KCountUp(
          begin: 0,
          end: KMathHelper.parseDouble(amount),
          duration: Duration(milliseconds: 500),
          // separator: this.tokenName == KMoney.USD ? "," : ".",
          // precision: this.tokenName == KMoney.VND ? 0 : 2,
          style: Theme.of(context).textTheme.headline1,
          formatter: (double d) => KUtil.prettyMoney(
            amount: "${d}",
            tokenName: tokenName,
            useCurrencySymbol: false,
          ),
        ),
      ),
    );
  }
}
