import 'package:app_core/app_core.dart';
import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreditReceipt extends StatefulWidget {
  final String transactionID;
  final String lineID;
  final String? tokenName;

  CreditReceipt({
    required this.transactionID,
    required this.lineID,
    this.tokenName,
  });

  @override
  State<StatefulWidget> createState() => _CreditReceiptState();
}

class _CreditReceiptState extends State<CreditReceipt> {
  KCreditTransaction? transaction;

  bool isSuccess = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadTransaction();
  }

  void loadTransaction() async {
    final response = await KServerHandler.getTx(
      transactionID: widget.transactionID,
      lineID: widget.lineID,
    );

    KCreditTransaction? theTX =
        response.transactions == null ? null : response.transactions!.first;

    setState(() {
      this.transaction = theTX;
      this.isSuccess = theTX != null;
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final icon = Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: this.isSuccess ? Colors.green : Theme.of(context).errorColor,
      ),
      child: Icon(
        this.isSuccess ? Icons.check : Icons.close,
        size: 60,
        color: Colors.white,
      ),
    );

    final info = this.transaction == null
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    KMoneyHelper.prettyMoney(
                      amount: this.transaction!.amount ?? "",
                      currency: KMoney.VND,
                      showSymbol: false,
                    ),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(
                        (this.transaction!.tokenName ?? "") +
                            ((this.transaction!.tokenName != "USD" &&
                                    this.transaction!.tokenName != null)
                                ? ""
                                : ""),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 18),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );

    final recipient = this.transaction == null
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.transaction!.lineType ==
                          KCreditTransaction.LINE_TYPE_CREDIT
                      ? "Transfer from"
                      : "Transfer to",
                  style: Theme.of(context).textTheme.subtitle2!,
                ),
                SizedBox(height: 8),
                Text(
                  this.transaction!.prettyName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                    "${this.transaction!.poiPUID}   @${this.transaction!.poiKUNM}",
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          );

    final transactionDescription = this.transaction == null
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(KUtil.prettyDate(this.transaction!.lineDate, showTime: true),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText1!),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Transaction",
                    style: Theme.of(context).textTheme.bodyText1!,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${this.transaction!.txID}",
                    style: Theme.of(context).textTheme.bodyText1!,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    this.transaction!.prettyXFRDescription,
                    style: Theme.of(context).textTheme.bodyText1!,
                  ),
                ],
              ),
            ]),
          );
    final memo = (this.transaction?.memo ?? "").isEmpty
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(children: [
              Row(
                children: [
                  Text(
                    "Memo",
                    style: Theme.of(context).textTheme.subtitle2!,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    this.transaction?.memo ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
            ]),
          );
    final body = this.isLoading && this.transaction == null
        ? Center(child: CircularProgressIndicator())
        : !this.isLoading && this.transaction == null
            ? Center(child: Text("Failed to load transaction"))
            : ScrollConfiguration(
                behavior: NoOverscroll(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: icon),
                        info,
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                        transactionDescription,
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                        recipient,
                        SizedBox(height: 8),
                        SizedBox(height: 8),
                        memo,
                      ],
                    ),
                  ),
                ),
              );

    return Scaffold(
      appBar: AppBar(title: Text("Transaction ${transaction?.txID ?? ""}")),
      body: body,
    );
  }
}
