import 'package:app_core/helper/kapp_nav_helper.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kbalance.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/model/response/get_balances_response.dart';
import 'package:app_core/model/response/get_credit_transactions_response.dart';
import 'package:app_core/ui/wallet/credit_bank_transfer.dart';
import 'package:app_core/ui/wallet/credit_receipt.dart';
import 'package:app_core/ui/wallet/wallet_transfer.dart';
import 'package:app_core/ui/wallet/widget/credit_token_picker.dart';
import 'package:app_core/ui/wallet/widget/kcredit_banner.dart';
import 'package:app_core/ui/wallet/widget/krole_picker.dart';
import 'package:app_core/ui/widget/kqr_viewer.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:app_core/app_core.dart';

class WalletFeed extends StatefulWidget {
  final String? defaultTokenName;
  final bool showBankButtons;
  final bool showDirectTransferButton;
  final bool showProxyTransferButton;
  final bool useScaffold;

  WalletFeed({
    this.defaultTokenName,
    required this.showBankButtons,
    required this.showDirectTransferButton,
    required this.showProxyTransferButton,
    this.useScaffold = true,
  });

  @override
  State<StatefulWidget> createState() => _WalletFeedState();
}

class _WalletFeedState extends State<WalletFeed> {
  late final String initialToken = widget.defaultTokenName ?? localeToken;

  KRole? proxyRole;
  GetBalancesResponse? _balancesResponse;
  GetCreditTransactionsResponse? _transactionsResponse;

  // timing issue?? maybe need some kind of timeout
  bool isLoaded = false;
  int balanceIndex = -1;

  String get localeToken => KLocaleHelper.isUSA ? KMoney.USD : KMoney.VND;

  KBalance? get balance {
    KBalance dummyBalance = KBalance()
      ..puid = "0"
      ..amount = "0"
      ..tokenName = initialToken;
    try {
      return _balancesResponse?.balances?[balanceIndex] ?? dummyBalance;
    } catch (_) {
      return dummyBalance;
    }
  }

  KTransferType get transferType =>
      proxyRole == null ? KTransferType.direct : KTransferType.proxy;

  String get tokenToLookFor => balance?.tokenName ?? initialToken;

  List<KCreditTransaction> get transactions =>
      _transactionsResponse?.transactions ?? [];

  @override
  void initState() {
    super.initState();
    loadData();

    // print("WALLET FEED - use scaffold??? - ${widget.useScaffold}");
  }

  @override
  void dispose() {
    this._balancesResponse = null;
    this._transactionsResponse = null;
    super.dispose();
  }

  void loadData() async {
    final response = await KServerHandler.getCreditBalances();
    if (mounted) {
      setState(() => _balancesResponse = response);

      int? index;
      try {
        index = _balancesResponse?.balances
            ?.indexWhere((b) => b.tokenName == tokenToLookFor);
      } catch (_) {}
      if ((index ?? -1) == -1) {
        index = 0;
      }
      setBalanceIndex(index!);
    }
    setState(() => isLoaded = true);
  }

  Future setBalanceIndex(int index) async {
    KBalance bal;
    try {
      bal = this._balancesResponse!.balances![index];
    } catch (_) {
      return;
    }

    final response = await KServerHandler.getCreditTransactions(
        tokenName: bal.tokenName ?? "");
    setState(() {
      this.balanceIndex = index;
      this._transactionsResponse = response;
    });
  }

  // void toCreditTransfer({String? refPUID}) async => await Navigator.of(context)
  //     .push(MaterialPageRoute(
  //       builder: (ctx) => CreditTransfer(
  //         initialPUID: refPUID ?? "",
  //         tokenName: widget.tokenName,
  //       ),
  //     ))
  //     .then((_) => loadData());

  void onTransactionClick(KCreditTransaction transaction) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => CreditReceipt(
            transactionID: transaction.txID ?? "",
            lineID: transaction.lineID ?? "",
            tokenName: widget.defaultTokenName,
          ),
        ),
      );

  void onWithdrawClick() async => Navigator.of(context)
      .push(MaterialPageRoute(
          builder: (ctx) => CreditBankTransfer(
                tokenName: this.balance?.tokenName ?? "",
                action: BankTransferAction.withdraw,
              )))
      .whenComplete(loadData);

  void onDepositClick() async => Navigator.of(context)
      .push(MaterialPageRoute(
          builder: (ctx) => CreditBankTransfer(
                tokenName: this.balance?.tokenName ?? "",
                action: BankTransferAction.deposit,
              )))
      .whenComplete(loadData);

  void onTransferClick() => Navigator.of(context)
      .push(MaterialPageRoute(
          builder: (ctx) => WalletTransfer(
                sndRole: proxyRole,
                transferType: transferType,
                tokenName: balance?.tokenName ?? "",
              )))
      .whenComplete(loadData);

  // void onDirectTransferClick() => Navigator.of(context)
  //     .push(MaterialPageRoute(
  //         builder: (ctx) => CreditSend(tokenName: balance?.tokenName ?? "")))
  //     .whenComplete(loadData);
  //
  // void onBXFRClick() => Navigator.of(context)
  //     .push(MaterialPageRoute(
  //         builder: (ctx) => ProxyTransfer(tokenName: balance?.tokenName ?? "")))
  //     .whenComplete(loadData);

  void onTokenNameClick(int index) => setBalanceIndex(index);

  void showQR() {
    final qrData = {'puid': KSessionData.me?.puid ?? ""};
    final screen = KQRViewer(qrData: qrData);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void showChooseTokenModal() => showModalBottomSheet<void>(
        context: context,
        builder: (_) => CreditTokenPicker(
          balances: this._balancesResponse?.balances ?? [],
          onSelect: (bal) => onTokenNameClick(
              this._balancesResponse?.balances?.indexOf(bal) ?? -1),
        ),
      );

  void onProxyRoleChange(KRole? role) async {
    setState(() => proxyRole = role);
    print("CHOSE ROLE - ${role?.bnm}");
  }

  @override
  Widget build(BuildContext context) {
    final balanceView = this.balance == null
        ? Container()
        : KCreditBanner(
            amount: this.balance!.amount ?? "",
            tokenName: this.balance!.tokenName ?? "",
          );

    final transactionList = this.transactions.isEmpty
        ? Center(child: Text("No transaction found"))
        : ListView.builder(
            primary: false,
            itemCount: this.transactions.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 100),
            itemBuilder: (_, i) => _CreditFeedItem(
              this.transactions[i],
              this.transactions[i].tokenName ?? this.balance?.tokenName ?? "",
              onClick: onTransactionClick,
            ),
          );

    final bankButtons = Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed:
                  KAppNavHelper.pay == KAppNav.READONLY ? null : onDepositClick,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 6),
                  Text(KPhrases.deposit),
                ],
              ),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: ElevatedButton(
              onPressed: KAppNavHelper.pay == KAppNav.READONLY
                  ? null
                  : onWithdrawClick,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_outlined),
                  SizedBox(width: 6),
                  Text(KPhrases.withdrawal),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final transferButton = ElevatedButton(
      onPressed: onTransferClick, //onDirectTransferClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.send),
          SizedBox(width: 6),
          Text(KPhrases.directTransfer),
        ],
      ),
    );

    // final bxfrButton = ElevatedButton(
    //   onPressed: onTransferClick, // onBXFRClick,
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Icon(Icons.code),
    //       SizedBox(width: 6),
    //       Text(KPhrases.proxyTransfer),
    //     ],
    //   ),
    // );

    final tokenNameButton = InkWell(
      onTap: (this._balancesResponse?.balances ?? []).length > 0
          ? showChooseTokenModal
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.list, color: Colors.black, size: 18),
            SizedBox(width: 6),
            Text(
              this.balance?.tokenName ?? "",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.blue),
            ),
          ],
        ),
      ),
    );

    final balanceCard = Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 80,
              child: Center(child: balanceView),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(right: 30),
                child: tokenNameButton,
              ),
            ),
          ],
        ),
      ),
    );

    final content = SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            balanceCard,
            if (widget.showBankButtons) ...[
              SizedBox(height: 14),
              bankButtons,
            ],
            if (widget.showDirectTransferButton) ...[
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: transferButton,
              ),
            ],
            // if (widget.showProxyTransferButton) ...[
            //   SizedBox(height: 6),
            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: 20.0),
            //     child: bxfrButton,
            //   ),
            // ],
            SizedBox(height: 12),
            transactionList,
          ],
        ),
      ),
    );

    final body = !this.isLoaded ? Container() : content;

    final showQrButton = IconButton(
      onPressed: showQR,
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
        ),
        child: Image.asset(KAssets.IMG_QR_CODE, package: 'app_core'),
      ),
    );

    final proxyButton = KRolePicker(onChange: onProxyRoleChange);

    final actions = [
      showQrButton,
      if (widget.showProxyTransferButton) proxyButton,
    ];

    final withoutScaffold = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actions,
        ),
        body,
      ],
    );

    final withScaffold = Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.8),
        title: Text("Wallet"),
        actions: actions,
      ),
      body: body,
    );

    return widget.useScaffold ? withScaffold : withoutScaffold;
  }
}

class _CreditFeedItem extends StatelessWidget {
  final KCreditTransaction transaction;
  final String tokenName;
  final Function(KCreditTransaction)? onClick;

  const _CreditFeedItem(this.transaction, this.tokenName, {this.onClick});

  Widget transactorPrettyName(ctx, String name) => Text(
        name,
        style: Theme.of(ctx).textTheme.subtitle1,
      );

  Widget transactionID(ctx, String txID) => Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "ID $txID",
          style: Theme.of(ctx).textTheme.subtitle2,
        ),
      );

  Text transactionMethod(ctx, String txMethod) => Text(
        txMethod,
        style: Theme.of(ctx).textTheme.subtitle2,
      );

  Widget transactionDate(ctx, String date) => Text(
        KUtil.prettyDate(date, abbreviate: true),
        style: Theme.of(ctx).textTheme.subtitle2,
      );

  Widget amountChange(ctx, String amount, String tokenName) => Align(
        alignment: Alignment.topRight,
        child: Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: KUtil.prettyMoney(amount: amount, tokenName: tokenName),
                style: Theme.of(ctx).textTheme.subtitle1,
                // style: TextStyle(
                //   fontWeight: FontWeight.w600,
                //   color: amount.contains('-') ? Colors.red : Colors.green,
                //   fontSize: 18,
                // ),
              ),
            ),
          ],
        ),
      );

  Widget socialName(ctx, String name) {
    final String z;
    // TODO - deprecate case 1,2,5,6
    switch (name) {
      case "1":
        z = ""; // "Fee";
        break;
      case "2":
        z = ""; // "Escrow";
        break;
      case "5":
        z = ""; // "Deposit";
        break;
      case "6":
        z = ""; // "Withdrawal";
        break;
      default:
        z = KStringHelper.isEmpty(name) ? "" : "@$name";
        break;
    }
    return Text(z, style: Theme.of(ctx).textTheme.subtitle1);
  }

  @override
  Widget build(BuildContext context) {
    final body = GestureDetector(
      onTap: this.onClick == null
          ? null
          : () => this.onClick?.call(this.transaction),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    transactionDate(context, this.transaction.lineDate ?? ""),
                    amountChange(
                      context,
                      this.transaction.amount ?? "0",
                      this.tokenName,
                    ),
                  ],
                ),
                if (!KStringHelper.isEmpty(this.transaction.prettyName) &&
                    !KStringHelper.isEmpty(this.transaction.poiKUNM)) ...[
                  SizedBox(height: 5),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      transactorPrettyName(
                          context, this.transaction.prettyName),
                      SizedBox(
                        width: 8,
                      ),
                      socialName(context, this.transaction.poiKUNM ?? ""),
                    ],
                  ),
                ],
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    transactionMethod(
                      context,
                      this.transaction.prettyXFRDescription,
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     transactionID(context, this.transaction.txID ?? ""),
                //     transactionDate(context, this.transaction.lineDate ?? ""),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );

    return body;
  }
}
