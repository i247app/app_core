import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kapp_nav_helper.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kbalance.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/model/response/get_balances_response.dart';
import 'package:app_core/model/response/get_credit_transactions_response.dart';
import 'package:app_core/model/xfr_proxy.dart';
import 'package:app_core/ui/wallet/credit_bank_transfer.dart';
import 'package:app_core/ui/wallet/transfer_receipt.dart';
import 'package:app_core/ui/wallet/wallet_transfer.dart';
import 'package:app_core/ui/wallet/widget/credit_token_picker.dart';
import 'package:app_core/ui/wallet/widget/kcredit_banner.dart';
import 'package:app_core/ui/wallet/widget/krole_picker.dart';
import 'package:app_core/ui/widget/kqr_viewer.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/material.dart';

class WalletHome extends StatefulWidget {
  final String? defaultTokenName;
  final bool showBankButtons;
  final bool isDirectTransferEnabled;
  final bool isPartOfBubba; // Hacky but also only affects UI

  WalletHome({
    this.defaultTokenName,
    required this.showBankButtons,
    required this.isDirectTransferEnabled,
    this.isPartOfBubba = false,
  });

  @override
  State<StatefulWidget> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  late final String initialToken = widget.defaultTokenName ?? localeToken;

  final xfrRoleCtrl = ValueNotifier<KRole?>(null);
  final xfrProxiesCtrl = ValueNotifier<List<XFRProxy>?>(null);
  final balanceTokenCtrl = ValueNotifier<String?>(null);

  GetBalancesResponse? _balancesResponse;
  GetCreditTransactionsResponse? _transactionsResponse;

  // timing issue?? maybe need some kind of timeout
  bool isLoaded = false;
  late Widget wRolePicker = KRolePicker(onChange: onProxyRoleChange);

  String get localeToken => KLocaleHelper.isUSA ? KMoney.USD : KMoney.VND;

  KBalance? get currentBalance {
    try {
      // print("CURRENT TOKEN - ${balanceTokenCtrl.value}");
      // print(
      //     "FILTERED BALANCES - ${proxyFilteredBalances.map((b) => b.tokenName).join(", ")}");
      return proxyFilteredBalances
          .firstWhere((b) => b.tokenName == balanceTokenCtrl.value);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  KTransferType get transferType =>
      xfrRoleCtrl.value == null ? KTransferType.direct : KTransferType.proxy;

  String get tokenToLookFor => currentBalance?.tokenName ?? initialToken;

  List<KCreditTransaction> get transactions =>
      _transactionsResponse?.transactions ?? [];

  List<KBalance> get proxyFilteredBalances {
    final bal = _balancesResponse?.balances ?? [];
    final xfrProxiesTokens =
        (xfrProxiesCtrl.value ?? []).map((p) => p.tokenName);
    return (xfrRoleCtrl.value == null
            ? bal
            : bal.where((b) => xfrProxiesTokens.contains(b.tokenName)))
        .toList();
  }

  bool get isTransferButtonEnabled =>
      transferType != KTransferType.direct || widget.isDirectTransferEnabled;

  @override
  void initState() {
    super.initState();

    xfrRoleCtrl.addListener(xfrRoleListener);
    xfrProxiesCtrl.addListener(xfrProxiesListener);
    balanceTokenCtrl.addListener(balanceTokenListener);

    loadBalances();
  }

  @override
  void dispose() {
    xfrRoleCtrl.removeListener(xfrRoleListener);
    xfrProxiesCtrl.removeListener(xfrProxiesListener);
    balanceTokenCtrl.removeListener(balanceTokenListener);
    super.dispose();
  }

  void xfrRoleListener() async {
    // Clear out old xfr proxies
    xfrProxiesCtrl.value = null;

    // Load in new xfr proxies
    if (xfrRoleCtrl.value != null) {
      final response =
          await KServerHandler.listXFRProxy(xfrRoleCtrl.value?.buid ?? "");
      if (response.isSuccess) {
        xfrProxiesCtrl.value = response.proxies;
      }
    }

    loadBalances();
    // loadTransactions();
  }

  void xfrProxiesListener() async {
    if (mounted) {
      setState(() {});
    }
  }

  void balanceTokenListener() async {
    loadTransactions();
  }

  Future loadTransactions() async {
    KBalance? bal = currentBalance;
    if (bal == null) {
      if (mounted) {
        setState(() => _transactionsResponse = null);
      }
    } else {
      final response = await KServerHandler.getCreditTransactions(
        tokenName: bal.tokenName ?? "",
        proxyPUID: xfrRoleCtrl.value?.buid,
      );
      if (mounted) {
        setState(() => _transactionsResponse = response);
      }
    }
  }

  Future loadBalances() async {
    final response = await KServerHandler.getCreditBalances(
        proxyPUID: xfrRoleCtrl.value?.buid);

    if (mounted) {
      setState(() => _balancesResponse = response);

      setState(() => isLoaded = false);

      try {
        final hasInitialToken = proxyFilteredBalances
            .where((b) => b.tokenName == tokenToLookFor)
            .isNotEmpty;
        if (hasInitialToken) {
          balanceTokenCtrl.value = tokenToLookFor;
        } else {
          balanceTokenCtrl.value = proxyFilteredBalances.first.tokenName;
        }
      } catch (e) {
        print(e.toString());
      }
      setState(() => isLoaded = true);
    }
  }

  void onTransactionClick(KCreditTransaction transaction) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => TransferReceipt(
            transactionID: transaction.txID ?? "",
            lineID: transaction.lineID ?? "",
            tokenName: widget.defaultTokenName,
          ),
        ),
      );

  Future loadAllData() async => Future.wait([
        loadBalances(),
        loadTransactions(),
      ]);

  void onWithdrawClick() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => CreditBankTransfer(
              total: currentBalance?.amount ?? "",
              tokenName: currentBalance?.tokenName ?? "",
              action: BankTransferAction.withdraw,
            )));
    showReceipt(result);
  }

  void showReceipt(dynamic result) async {
    if (result != null) {
      final transaction = result as KCreditTransaction;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => TransferReceipt(
            transactionID: transaction.txID ?? "",
            lineID: transaction.lineID ?? "",
            tokenName: currentBalance?.tokenName ?? "",
          ),
        ),
      );
      await loadAllData();
    }
  }

  void onDepositClick() async {
    final result = Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => CreditBankTransfer(
              total: currentBalance?.amount ?? "",
              tokenName: currentBalance?.tokenName ?? "",
              action: BankTransferAction.deposit,
            )));
    showReceipt(result);
  }

  void toChooseContact() async {}

  void onTransferClick() async {
    final KUser? user = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => KChooseContact(contactType: KContactType.transfer)));
    if (user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (ctx) => KUtil.getPaymentScreen(
                    user: user,
                    sndRole: xfrRoleCtrl.value,
                    transferType: transferType,
                    tokenName: currentBalance?.tokenName ?? "",
                    rcvPUID: null,
                  )))
          .whenComplete(loadAllData);
    }
  }

  void onTokenNameClick(String token) => balanceTokenCtrl.value = token;

  void showQR() {
    final qrData = {'puid': KSessionData.me?.puid ?? ""};
    final screen = KQRViewer(qrData: qrData);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void showChooseTokenModal() => showModalBottomSheet<void>(
        context: context,
        builder: (_) => CreditTokenPicker(
          balances: proxyFilteredBalances,
          onSelect: (bal) => onTokenNameClick(bal.tokenName ?? ""),
        ),
      );

  void onProxyRoleChange(KRole? role) async => xfrRoleCtrl.value = role;

  @override
  Widget build(BuildContext context) {
    final balanceView = Container(
      height: 80,
      child: Center(
        child: _balancesResponse == null
            ? Text("Loading...")
            : currentBalance == null
                ? KCreditBanner(
                    amount: "0",
                    tokenName: "",
                  ) // Text("No Balance")
                : KCreditBanner(
                    amount: currentBalance!.amount ?? "",
                    tokenName: currentBalance!.tokenName ?? "",
                  ),
      ),
    );

    final transactionList = transactions.isEmpty
        ? Center(child: Text(KPhrases.noData))
        : ListView.builder(
            primary: false,
            itemCount: transactions.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 100),
            itemBuilder: (_, i) => _WalletItem(
              transactions[i],
              transactions[i].tokenName ?? currentBalance?.tokenName ?? "",
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

    final tokenNameDisplay = Container(
      padding: EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.list, size: 18),
          SizedBox(width: 6),
          Text(
            currentBalance?.tokenName ?? "    ",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.blue),
          ),
        ],
      ),
    );

    final balanceCard = Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: InkWell(
        onTap: proxyFilteredBalances.length > 0 ? showChooseTokenModal : null,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 1,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black26,
                      size: 44,
                    ),
                  ),
                  Expanded(child: balanceView),
                  Opacity(
                    opacity: 0,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black26,
                      size: 44,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  child: tokenNameDisplay,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SafeArea(child: Container()),
        balanceCard,
        if (widget.showBankButtons) ...[
          SizedBox(height: 14),
          bankButtons,
        ],
        if (isTransferButtonEnabled) ...[
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: transferButton,
          ),
        ],
        SizedBox(height: 12),
        transactionList,
      ],
    );

    final body = !isLoaded ? Container() : content;

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

    final actions = [
      showQrButton,
      wRolePicker,
    ];

    final withoutScaffold = RefreshIndicator(
      onRefresh: loadAllData,
      child: ListView(
        children: [
          if (widget.isPartOfBubba) SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: actions,
          ),
          body,
        ],
      ),
    );

    final withScaffold = Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.8),
        title: Text("Wallet"),
        actions: actions,
      ),
      body: RefreshIndicator(
        onRefresh: loadAllData,
        child: SingleChildScrollView(child: body),
      ),
    );

    return (widget.isPartOfBubba || KEmbedManager.of(context).isEmbed)
        ? withoutScaffold
        : withScaffold;
  }
}

class _WalletItem extends StatelessWidget {
  final KCreditTransaction transaction;
  final String tokenName;
  final Function(KCreditTransaction)? onClick;

  const _WalletItem(this.transaction, this.tokenName, {this.onClick});

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
    final body = Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onClick == null ? null : () => onClick?.call(transaction),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (KStringHelper.isExist(transaction.prettyName)) ...[
                Text(
                  transaction.prettyName,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 5),
              ],
              if (KStringHelper.isExist(transaction.poiPUID) &&
                  KStringHelper.isExist(transaction.poiKUNM)) ...[
                Text(
                  "${transaction.poiPUID}   @${transaction.poiKUNM}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 5),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  transactionDate(context, transaction.lineDate ?? ""),
                  amountChange(
                    context,
                    transaction.amount ?? "0",
                    tokenName,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  transactionMethod(
                    context,
                    transaction.prettyXFRDescription,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  transactionID(context, transaction.txID ?? ""),
                  transactionDate(context, transaction.lineDate ?? ""),
                ],
              ),
              if (transaction.memo != null) ...[
                SizedBox(height: 5),
                Text(
                  transaction.memo ?? "",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return body;
  }
}
