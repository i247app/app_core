import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/credit/credit_receipt.dart';
import 'package:app_core/ui/credit/widget/kcredit_banner.dart';
import 'package:app_core/ui/widget/kkeyboard_killer.dart';
import 'package:app_core/ui/widget/old_contact_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreditSend extends StatefulWidget {
  final String? initialPUID;
  final String? tokenName;

  CreditSend({this.initialPUID, this.tokenName});

  @override
  State<StatefulWidget> createState() => _CreditSendState();
}

class _CreditSendState extends State<CreditSend> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool isBalanceLoaded = false;
  bool isTransferring = false;

  String? balance;
  String? balanceTokenName;
  KUser? selectedUser;

  @override
  void initState() {
    super.initState();

    loadBalance();

    if (widget.initialPUID != null) loadUserInfo(puid: widget.initialPUID!);
  }

  void loadBalance() async {
    // Load balance
    final response = await KServerHandler.getCreditBalances(
//      tokenName: balanceTokenName,
      tokenName: widget.tokenName,
    );

    if (mounted) {
      setState(() {
        balance = response.balances
            ?.firstWhere((b) => b.tokenName == widget.tokenName)
            .amount;
        balanceTokenName = widget.tokenName;
      });
    }
  }

  void attemptTransferCredit() {
    String puid = "${selectedUser?.puid ?? ""}";
    String amount = amountController.text;

    if (KStringHelper.isExist(puid) && KStringHelper.isExist(amount))
      transferCredit(
        puid: puid,
        amount: amount,
        tokenName: widget.tokenName,
      );

    FocusScope.of(context).requestFocus(FocusNode()); // dismiss keyboard
  }

  void transferCredit(
      {required String puid, required String amount, String? tokenName}) async {
    setState(() => this.isTransferring = true);

    final response = await KServerHandler.transferCredit(
      puid: puid,
      amount: amount,
      tokenName: tokenName,
    );

    switch (response.kstatus) {
      case 100:
        if (response.transaction != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => CreditReceipt(
              transactionID: response.transaction!.txID ?? "",
              lineID: response.transaction!.lineID ?? "",
              tokenName: widget.tokenName,
            ),
          ));
        }

        break;
      case 2104:
        // multiple toast unlti a better solution
        KToastHelper.show("Insufficient funds",
            backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        KToastHelper.show("Insufficient funds",
            backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        // do noting
        break;
      case 400:
        KToastHelper.show("Transfer failed",
            backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        KToastHelper.show("Transfer failed",
            backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        break;
      default:
        KToastHelper.show("Transfer failed",
            backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        if (response.kmessage != null && !response.kmessage!.isEmpty)
          KToastHelper.show(response.kmessage ?? "",
              backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        else
          KToastHelper.show("Transfer failed",
              backgroundColor: Colors.red, toastLength: Toast.LENGTH_LONG);
        break;
    }
    setState(() => this.isTransferring = false);
  }

  void toChooseContact() async {
    final String? puid = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => OldContactSearch()));
    if (puid != null) loadUserInfo(puid: puid);
  }

  void loadUserInfo({required String puid}) async {
    final response = await KServerHandler.getUsers(puid: "$puid");
    if (response.users != null && response.users!.length > 0) {
      KUser user = response.users!.first;
      setState(() {
        this.selectedUser = user;
        this.userController.text = !(user.kunm ?? "").isEmpty
            ? (KUtil.chatDisplayName(
                    kunm: user.kunm,
                    fnm: user.firstName ?? "",
                    mnm: user.middleName ?? "",
                    lnm: user.lastName ?? "") ??
                "")
            : KUtil.prettyFone(
                foneCode: user.phoneCode ?? "",
                number: user.phone ?? "",
              );
      });
    }
  }

  void onScanQR() async {
    KScanResult result = await KScanHelper.scan();
    try {
      Map data = jsonDecode(result.data ?? "");
      String puid = data["puid"];
      loadUserInfo(puid: puid);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceBanner = KCreditBanner(
      amount: this.balance ?? "",
      tokenName: this.balanceTokenName ?? "",
    );

    final transferTo = _CreditInput(
      controller: userController,
      label: "Transfer To",
      asset: KAssets.IMG_PROFILE,
      keyboardType: TextInputType.text,
      onClick: toChooseContact,
    );

    final transferAmount = _CreditInput(
      controller: amountController,
      label: "Transfer Amount",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );

    final sendButton = ElevatedButton(
      onPressed: attemptTransferCredit,
      child: Text("TRANSFER"),
    );

    final body = ScrollConfiguration(
      behavior: NoOverscroll(),
      child: KeyboardKiller(
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          children: <Widget>[
            balanceBanner,
            Text(
              "Balance",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 40),
            transferTo,
            SizedBox(height: 20),
            transferAmount,
            SizedBox(height: 20),
            isTransferring
                ? Center(child: CircularProgressIndicator())
                : sendButton,
            SizedBox(height: 10),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Transfer"), actions: <Widget>[
        IconButton(
          onPressed: onScanQR,
          icon: Image.asset(
            KAssets.IMG_QR_SCAN,
            color: Theme.of(context).accentColor,
          ),
        )
      ]),
      body: body,
    );
  }
}

class _CreditInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? asset;
  final TextInputType keyboardType;
  final Function()? onClick;

  _CreditInput({
    required this.controller,
    required this.label,
    this.asset,
    this.onClick,
    this.keyboardType = TextInputType.text,
  });

  void clickHandler(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    onClick!.call();
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      this.label,
      style: Theme.of(context).textTheme.subtitle1,
    );

    final icon = this.asset == null
        ? null
        : Container(
            width: 10,
            padding: EdgeInsets.all(10),
            child: Image.asset(
              this.asset!,
              color: Theme.of(context).accentColor,
            ),
          );

    final input = TextField(
      controller: this.controller,
      keyboardType: this.keyboardType,
      textInputAction: TextInputAction.done,
      onTap: onClick == null ? null : () => clickHandler(context),
      // style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: icon),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text,
        SizedBox(height: 8),
        input,
      ],
    );
  }
}
