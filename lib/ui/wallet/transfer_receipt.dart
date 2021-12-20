import 'package:app_core/app_core.dart';
import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kcredit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransferReceipt extends StatefulWidget {
  final String transactionID;
  final String lineID;
  final String? tokenName;

  TransferReceipt({
    required this.transactionID,
    required this.lineID,
    this.tokenName,
  });

  @override
  State<StatefulWidget> createState() => _TransferReceiptState();
}

class _TransferReceiptState extends State<TransferReceipt> {
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

    final amountInfo = this.transaction == null
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
                      ? "TRANSFER FROM"
                      : "TRANSFER TO",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  this.transaction!.prettyName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                Text(
                    "${this.transaction!.poiPUID}   @${this.transaction!.poiKUNM}",
                    style: Theme.of(context).textTheme.subtitle1),
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
                  style: Theme.of(context).textTheme.subtitle1!),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "ID",
                    style: Theme.of(context).textTheme.subtitle1!,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${this.transaction!.txID}",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    this.transaction!.prettyXFRDescription,
                    style: Theme.of(context).textTheme.subtitle2,
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
                    "MEMO",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    this.transaction?.memo ?? "",
                    style: Theme.of(context).textTheme.subtitle1,
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
                        amountInfo,
                        SizedBox(height: 16),
                        recipient,
                        SizedBox(height: 16),
                        memo,
                        SizedBox(height: 20),
                        transactionDescription,
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
