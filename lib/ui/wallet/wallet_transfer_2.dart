import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/model/response/credit_transfer_response.dart';
import 'package:app_core/model/xfr_ticket.dart';
import 'package:app_core/ui/wallet/credit_receipt.dart';
import 'package:app_core/ui/wallet/wallet_transfer.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletTransfer2 extends StatefulWidget {
  final String? rcvPUID;
  final KRole? sndRole;
  final KTransferType transferType;
  final String tokenName;

  WalletTransfer2({
    this.rcvPUID,
    this.sndRole,
    required this.transferType,
    required this.tokenName,
  });

  @override
  State<StatefulWidget> createState() => _WalletTransfer2State();
}

class _WalletTransfer2State extends State<WalletTransfer2> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();

  String? balanceAmount;
  KUser? selectedUser;

  bool isNetworking = false;

  void Function()? get actionButtonHandler {
    if (!(amountCtrl.text.isNotEmpty &&
        (double.tryParse(amountCtrl.text) ?? 0) > 0)) {
      return null;
    } else if (selectedUser == null) {
      return toChooseContact;
    } else {
      return attemptTransferCredit;
    }
  }

  @override
  void initState() {
    super.initState();

    loadBalance();

    amountCtrl.text = "0";
    amountCtrl.addListener(fieldListener);

    if (widget.rcvPUID != null) loadUserInfo(puid: widget.rcvPUID!);
  }

  @override
  void dispose() {
    amountCtrl.removeListener(fieldListener);
    super.dispose();
  }

  void fieldListener() => setState(() {});

  void loadBalance() async {
    // Load balance
    final response = await KServerHandler.getCreditBalances(
      tokenName: widget.tokenName,
      proxyPUID: widget.sndRole?.buid,
    );

    if (mounted) {
      setState(() {
        balanceAmount = response.balances
            ?.firstWhere((b) => b.tokenName == widget.tokenName)
            .amount;
      });
    }
  }

  void attemptTransferCredit() {
    final rcvPUID = selectedUser?.puid ?? "";
    final amount = amountCtrl.text.endsWith(".")
        ? amountCtrl.text.replaceAll(".", "")
        : amountCtrl.text;

    if (rcvPUID.isNotEmpty && amount.isNotEmpty) {
      transferCredit(
        rcvPUID: rcvPUID,
        amount: amount,
        tokenName: widget.tokenName,
      );
    }

    FocusScope.of(context).unfocus(); // dismiss keyboard
  }

  void transferCredit({
    required String rcvPUID,
    required String amount,
    String? tokenName,
  }) async {
    try {
      setState(() => isNetworking = true);

      final ticket = XFRTicket(
        sndPUID: widget.sndRole?.buid,
        rcvPUID: rcvPUID,
        amount: amount,
        tokenName: tokenName,
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
            await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => CreditReceipt(
                transactionID: theTx!.txID ?? "",
                lineID: theTx.lineID ?? "",
                tokenName: widget.tokenName,
              ),
            ));
          } else {
            KToastHelper.fromResponse(response);
          }
          loadBalance();
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

  void onRecipientClick() async => toChooseContact();

  void onScanQR() async {
    final result = await KScanHelper.scan();
    try {
      final data = jsonDecode(result.data ?? "");
      final puid = data["puid"];
      loadUserInfo(puid: puid);
    } catch (e) {
      print(e.toString());
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

    final balanceView = () {
      final amt = KUtil.prettyMoney(
        amount: balanceAmount ?? "",
        tokenName: widget.tokenName,
      );
      // ignore: unused_local_variable
      final alexVersion = Text("You have $amt available");
      // Good version (Ron said)
      final balanceText = Text("Balance: $amt");
      return balanceAmount == null ? Text("") : balanceText;
    }.call();

    final transferTo = _CreditInput(
      controller: userController,
      label: "Transfer To",
      asset: KAssets.IMG_PROFILE,
      keyboardType: TextInputType.text,
      onClick: toChooseContact,
    );

    final transferAmount = FittedBox(
      fit: BoxFit.contain,
      child: Text(
        prettyPartialDecimal(amountCtrl.text),
        // KUtil.prettyMoney(
        //   amount: amountController.text,
        //   tokenName: widget.tokenName,
        //   useCurrencySymbol: false,
        // ),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    final sendButton = ElevatedButton(
      onPressed: actionButtonHandler,
      child: Container(
        height: 26,
        child: Center(
          child: isNetworking
              ? CircularProgressIndicator()
              : selectedUser == null
                  ? Text("CHOOSE RECIPIENT")
                  : Text("TRANSFER"),
        ),
      ),
    );

    final body = Container(
      padding: EdgeInsets.all(6),
      child: Column(
        children: <Widget>[
          if (widget.sndRole != null) roleDisplay,
          Expanded(child: transferAmount),
          Center(child: balanceView),
          Expanded(
            child: KNumberPad(
              controller: amountCtrl,
              onReturn: () {},
              style: KNumberPadStyle.CASHAPP,
              decimals: widget.tokenName == KMoney.VND ? 0 : 2,
            ),
          ),
          SizedBox(height: 10),
          sendButton,
        ],
      ),
    );

    final actions = [
      IconButton(
        onPressed: onRecipientClick,
        icon: selectedUser == null
            ? KUserAvatar(initial: "?")
            : KUserAvatar.fromUser(selectedUser!),
      ),
      IconButton(
        onPressed: onScanQR,
        icon: Image.asset(
          KAssets.IMG_QR_SCAN,
          package: 'app_core',
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ];

    return KeyboardKiller(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: CloseButton(),
          actions: actions,
        ),
        body: SafeArea(child: body),
      ),
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
