import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/ui/wallet/transfer_confirm.dart';
import 'package:app_core/ui/widget/keyboard_killer.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

enum KTransferType { direct, proxy }

class WalletTransfer extends StatefulWidget {
  final String? rcvPUID;
  final KRole? sndRole;
  final KTransferType transferType;
  final String tokenName;
  final KUser? user;

  WalletTransfer({
    this.rcvPUID,
    this.sndRole,
    this.user,
    required this.transferType,
    required this.tokenName,
  });

  @override
  State<StatefulWidget> createState() => _WalletTransferState();
}

class _WalletTransferState extends State<WalletTransfer> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();

  String? balanceAmount;
  KUser? selectedUser;

  bool isNetworking = false;

  void Function()? get actionButtonHandler {
    final amount = double.tryParse(amountCtrl.text) ?? 0;
    selectedUser = widget.user;

    if (amount > (double.tryParse(balanceAmount ?? "0") ?? 0) || amount == 0) {
      return null;
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

  void attemptTransferCredit() async {
    FocusScope.of(context).unfocus(); // dismiss keyboard

    final rcvPUID = selectedUser?.puid ?? "";
    final amount = amountCtrl.text.endsWith(".")
        ? amountCtrl.text.replaceAll(".", "")
        : amountCtrl.text;

    if (rcvPUID.isNotEmpty && amount.isNotEmpty && selectedUser != null) {
      // Open TransferConfirm screen
      final result = await openConfirmScreen(
          amount, widget.tokenName, selectedUser!, balanceAmount ?? "");
      if (result != null) {
        Navigator.of(context).pop();
      }
    }
  }

  void toChooseContact() async {
    final KUser? user = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KChooseContact(contactType: KContactType.transfer)));
    if (user?.puid != null) loadUserInfo(puid: user!.puid!);
  }

  Future<dynamic> openConfirmScreen(
      String amout, String tokenName, KUser user, String balanceAmount) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TransferConfirm(
          sndRole: widget.sndRole,
          transferType: widget.transferType,
          amount: amout,
          tokenName: tokenName,
          user: user,
          balanceAmount: balanceAmount,
        ),
      ),
    );
    return Future.value(result);
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
        useCurrencyName: true,
        useCurrencySymbol: false,
        tokenToRight: true,
      );
      // ignore: unused_local_variable
      final alexVersion = Text("You have $amt available");
      // unnecessary nice lol

      final balanceText = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Balance",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).primaryColorLight),
          ),
          SizedBox(
            width: 32,
          ),
          Text(amt, style: Theme.of(context).textTheme.headline6)
        ],
      );
      return balanceAmount == null ? Text("") : balanceText;
    }.call();

    final transferTo = _CreditInput(
      controller: userController,
      label: "Transfer To",
      asset: KAssets.IMG_PROFILE,
      keyboardType: TextInputType.text,
      onClick: toChooseContact,
    );

    final transferAmount = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: FittedBox(
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
      ),
    );

    final sendButton = ElevatedButton(
      onPressed: actionButtonHandler,
      child: Container(
        height: 26,
        child: Center(
          child: isNetworking ? CircularProgressIndicator() : Text("NEXT"),
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
      InkWell(
        onTap: onRecipientClick,
        child: Row(
          children: [
            SizedBox(
              width: 230,
              height: 30,
              child: FittedBox(
                child: Text(selectedUser?.fullName ?? "",
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            SizedBox(width: 12),
            KUserAvatar.fromUser(selectedUser, size: 32)
          ],
        ),
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
