import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/chat/widget/kuser_profile_view.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class TransferConfirm extends StatefulWidget {
  final String amount;
  final String tokenName;
  final KUser user;
  final String balanceAmount;

  const TransferConfirm(
      {Key? key,
      required this.amount,
      required this.tokenName,
      required this.balanceAmount,
      required this.user})
      : super(key: key);

  @override
  _TransferConfirmState createState() => _TransferConfirmState();
}

class _TransferConfirmState extends State<TransferConfirm> {
  KUser get user => widget.user;
  final TextEditingController memoController = TextEditingController();
  String get balanceAmount =>
      "${(double.tryParse(widget.balanceAmount) ?? 0) - (double.tryParse(widget.amount) ?? 0)}";

  @override
  Widget build(BuildContext context) {
    final transferAmount = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          prettyPartialDecimal(widget.amount),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );

    final balanceView = () {
      final amt = KUtil.prettyMoney(
        amount: balanceAmount,
        tokenName: widget.tokenName,
        useCurrencyName: true,
        useCurrencySymbol: false,
        tokenToRight: true,
      );
      final balanceText = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Balance", style: Theme.of(context).textTheme.headline6),
          SizedBox(
            width: 32,
          ),
          Text(amt, style: Theme.of(context).textTheme.headline6)
        ],
      );
      return balanceText;
    }.call();

    final avatarAndNameRow = Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => KUserProfileView.fromUser(user))),
          child: Container(
            height: 32,
            child: KUserAvatar.fromUser(user, size: 32),
          ),
        ),
        SizedBox(width: 10),
        Text(
          user.fullName ?? "",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );

    final kunmRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${user.puid}   @${user.kunm}",
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );

    final titleMemo = Text("Memo",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left);
    final memoTextField = TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      maxLines: 5,
      controller: memoController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Optional",
        hintStyle: Theme.of(context).textTheme.caption,
      ),
    );

    final sendButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop(memoController.text);
      },
      child: Container(
        height: 26,
        child: Center(
          child: Text("TRANSFER"),
        ),
      ),
    );

    final body = Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [Expanded(child: transferAmount)],
            ),
            balanceView,
            SizedBox(height: 20),
            avatarAndNameRow,
            kunmRow,
            SizedBox(height: 20),
            titleMemo,
            memoTextField,
            SizedBox(height: 20),
            sendButton,
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: SafeArea(
        child: KeyboardKiller(child: SingleChildScrollView(child: body)),
      ),
    );
  }

  String prettyPartialDecimal(String rawAmount) {
    final endsWithPeriod = rawAmount.endsWith(".");
    final base = KUtil.prettyMoney(
      amount: rawAmount,
      tokenName: widget.tokenName,
      useCurrencySymbol: false,
    );
    if (endsWithPeriod) {
      return "$base.";
    } else {
      return base;
    }
  }
}
