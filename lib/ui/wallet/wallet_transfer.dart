import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/model/xfr_ticket.dart';
import 'package:app_core/ui/wallet/credit_receipt.dart';
import 'package:app_core/ui/wallet/widget/kcredit_banner.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum KTransferType { direct, proxy }

class WalletTransfer extends StatefulWidget {
  final String? rcvPUID;
  final KRole? sndRole;
  final KTransferType transferType;
  final String tokenName;

  WalletTransfer({
    this.rcvPUID,
    this.sndRole,
    required this.transferType,
    required this.tokenName,
  });

  @override
  State<StatefulWidget> createState() => _WalletTransferState();
}

class _WalletTransferState extends State<WalletTransfer> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? balanceAmount;
  KUser? selectedUser;

  bool isNetworking = false;

  bool get isButtonEnabled =>
      selectedUser != null && amountController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    loadBalance();

    amountController.addListener(fieldListener);

    if (widget.rcvPUID != null) loadUserInfo(puid: widget.rcvPUID!);
  }

  @override
  void dispose() {
    amountController.removeListener(fieldListener);
    super.dispose();
  }

  void fieldListener() => setState(() {});

  void loadBalance() async {
    // Load balance
    final response =
        await KServerHandler.getCreditBalances(tokenName: widget.tokenName);

    if (mounted) {
      setState(() {
        balanceAmount = response.balances
            ?.firstWhere((b) => b.tokenName == widget.tokenName)
            .amount;
      });
    }
  }

  void attemptTransferCredit() {
    final puid = selectedUser?.puid ?? "";
    final amount = amountController.text;

    if (puid.isNotEmpty && amount.isNotEmpty)
      transferCredit(
        rcvPUID: puid,
        amount: amount,
        tokenName: widget.tokenName,
      );

    FocusScope.of(context).unfocus(); // dismiss keyboard
  }

  void transferCredit({
    required String rcvPUID,
    required String amount,
    String? tokenName,
  }) async {
    setState(() => isNetworking = true);

    final ticket = XFRTicket(
      sndPUID: widget.sndRole?.puid,
      rcvPUID: rcvPUID,
      amount: amount,
      tokenName: tokenName,
    );
    final response = await KServerHandler.xfrDirect(ticket);

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
    setState(() => isNetworking = false);
  }

  void toChooseContact() async {
    final KUser? user = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KChooseContact()));
    if (user?.puid != null) loadUserInfo(puid: user!.puid!);
  }

  void loadUserInfo({required String puid}) async {
    final response = await KServerHandler.getUsers(puid: puid);
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
    final result = await KScanHelper.scan();
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
    final roleDisplay = widget.sndRole == null
        ? Container()
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              KUserAvatar(
                initial: widget.sndRole?.bnm,
                imageURL: widget.sndRole?.avatarURL,
                size: 32,
              ),
              SizedBox(width: 6),
              Text(
                widget.sndRole?.bnm ?? "",
                style: TextStyle(fontSize: 16),
              ),
            ],
          );

    final balanceBanner = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Opacity(opacity: 0, child: Text(widget.tokenName)),
          Expanded(
            child: KCreditBanner(
              amount: balanceAmount ?? "",
              tokenName: widget.tokenName,
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(widget.tokenName),
          ),
        ],
      ),
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
      onPressed: isButtonEnabled ? attemptTransferCredit : null,
      child: Text("TRANSFER"),
    );

    final body = ScrollConfiguration(
      behavior: NoOverscroll(),
      child: KeyboardKiller(
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          children: <Widget>[
            if (widget.sndRole != null) roleDisplay,
            Container(
              height: 100,
              child: balanceBanner,
            ),
            Text(
              "Balance",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 40),
            transferTo,
            SizedBox(height: 20),
            transferAmount,
            SizedBox(height: 20),
            isNetworking
                ? Center(child: CircularProgressIndicator())
                : sendButton,
          ],
        ),
      ),
    );

    final actions = [
      IconButton(
        onPressed: onScanQR,
        icon: Image.asset(
          KAssets.IMG_QR_SCAN,
          package: 'app_core',
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        // title: Text("Transfer"),
        actions: actions,
      ),
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
              package: 'app_core',
              color: Theme.of(context).colorScheme.secondary,
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
        suffixIcon: icon,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text,
        SizedBox(height: 8),
        input,
      ],
    );
  }
}
