import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/ktoast_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/model/response/credit_transfer_response.dart';
import 'package:app_core/model/xfr_ticket.dart';
import 'package:app_core/ui/chat/widget/kuser_view.dart';
import 'package:app_core/ui/wallet/transfer_receipt.dart';
import 'package:app_core/ui/wallet/wallet_transfer.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransferConfirm extends StatefulWidget {
  final String amount;
  final String tokenName;
  final KUser user;
  final KRole? sndRole;
  final KTransferType transferType;
  final String balanceAmount;

  const TransferConfirm(
      {Key? key,
      this.sndRole,
      required this.transferType,
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
  bool isNetworking = false;

  String get balanceAmount =>
      "${(double.tryParse(widget.balanceAmount) ?? 0) - (double.tryParse(widget.amount) ?? 0)}";

  @override
  Widget build(BuildContext context) {
    final transferAmount = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        height: 290,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            prettyPartialDecimal(widget.amount),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
          Text(
            "New Balance",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).primaryColorLight),
          ),
          SizedBox(
            width: 20,
          ),
          Text(amt, style: Theme.of(context).textTheme.subtitle1)
        ],
      );
      return balanceText;
    }.call();

    final avatarAndNameRow = Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => KUserView.fromUser(user))),
          child: Container(
            height: 32,
            child: KUserAvatar.fromUser(user, size: 32),
          ),
        ),
        SizedBox(width: 8),
        Text(
          user.fullName ?? "",
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );

    final kunmRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${user.puid} @${user.kunm}",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );

    final titleMemo = Text("Memo",
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Theme.of(context).primaryColorLight),
        textAlign: TextAlign.left);

    final memoTextField = TextField(
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      minLines: 1,
      //Normal textInputField will be displayed
      maxLines: 5,
      controller: memoController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: KPhrases.memoHintText,
        hintStyle: Theme.of(context).textTheme.caption,
      ),
    );

    final sendButton = ElevatedButton(
      onPressed: this.isNetworking
          ? null
          : () {
              transferCredit(
                  rcvPUID: widget.user.puid ?? "",
                  amount: widget.amount,
                  tokenName: widget.tokenName,
                  memo: memoController.text);
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
            SizedBox(height: 40),
            avatarAndNameRow,
            SizedBox(height: 8),
            kunmRow,
            SizedBox(height: 40),
            titleMemo,
            memoTextField,
            SizedBox(height: 40),
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

  void transferCredit(
      {required String rcvPUID,
      required String amount,
      String? tokenName,
      String? memo}) async {
    try {
      setState(() => isNetworking = true);

      final ticket = XFRTicket(
        sndPUID: widget.sndRole?.buid,
        rcvPUID: rcvPUID,
        amount: amount,
        tokenName: tokenName,
        memo: memo,
      );
      final Future<CreditTransferResponse> Function(XFRTicket) fn =
          widget.transferType == KTransferType.direct
              ? KServerHandler.xfrDirect
              : KServerHandler.xfrProxy;
      final response = await fn.call(ticket);

      setState(() => isNetworking = false);

      switch (response.kstatus) {
        case 100:
          final assPUIDToLookFor = widget.transferType == KTransferType.proxy
              ? widget.sndRole?.buid
              : KSessionData.me?.puid;
          KCreditTransaction? theTx;
          try {
            theTx = response.transactions?.firstWhere((t) {
              print("t.assPUID == ${t.assPUID}");
              print("assPUIDToLookFor == $assPUIDToLookFor");
              return t.assPUID == assPUIDToLookFor;
            });
          } catch (e) {
            print(e.toString());
          }
          if (theTx != null) {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => TransferReceipt(
                transactionID: theTx!.txID ?? "",
                lineID: theTx.lineID ?? "",
                tokenName: widget.tokenName,
              ),
            ));
            Navigator.of(context).pop(true);
          } else {
            KToastHelper.fromResponse(response);
          }
          // loadBalance();
          break;
        case 2104:
          // multiple toast until a better solution
          KToastHelper.show("Insufficient funds",
              backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
          // do noting
          break;
        case 400:
          KToastHelper.show("Transfer failed",
              backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
          break;
        default:
          KToastHelper.show(response.kmessage ?? "Transfer failed",
              backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
          break;
      }
    } catch (e) {
      print(e);
      print("release isNetworking = false");
      setState(() => isNetworking = false);
    }
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
