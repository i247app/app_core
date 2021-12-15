import 'package:app_core/header/kcore_code.dart';
import 'package:app_core/helper/kbank_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/ksnackbar_helper.dart';
import 'package:app_core/ui/kbank_picker.dart';
import 'package:app_core/ui/widget/profile_input.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

enum BankTransferAction { withdraw, deposit }

class CreditBankTransfer extends StatefulWidget {
  final String tokenName;
  final BankTransferAction action;

  const CreditBankTransfer({required this.tokenName, required this.action});

  @override
  _CreditBankTransferState createState() => _CreditBankTransferState();
}

class _CreditBankTransferState extends State<CreditBankTransfer> {
  final formKey = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  final accountNameCtrl = TextEditingController();
  final bankAccountNumberCtrl = TextEditingController();
  final bankCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    bankCtrl.text = KSessionData.me?.bankID ?? "100";
    bankAccountNumberCtrl.text = KSessionData.me?.bankAccNumber ?? "";
    accountNameCtrl.text = KSessionData.me?.bankAccName ?? "";
  }

  void onSubmitClick() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }

    bool hasModifyBank = false;
    final bankID = this.bankCtrl.text;
    final banks = await KBankHelper.getBanks();
    final bankName =
        banks![int.parse(this.bankCtrl.text) - 100].shortName ?? "";

    if ((KSessionData.me?.bankName ?? "") != bankName ||
        (KSessionData.me?.bankAccName ?? "") != accountNameCtrl.text ||
        (KSessionData.me?.bankAccNumber ?? "") != bankAccountNumberCtrl.text) {
      final response = await KServerHandler.modifyUserBank(
        bankID: bankID,
        bankName: bankName,
        bankAccount: accountNameCtrl.text,
        bankAccNumber: bankAccountNumberCtrl.text,
      );
      if (response.kstatus != KCoreCode.SUCCESS) {
        KSnackBarHelper.show(
          text: response.kmessage ?? "",
          isSuccess: false,
        );
        return;
      }
      hasModifyBank = true;
    }

    final apiCall = widget.action == BankTransferAction.withdraw
        ? KServerHandler.bankWithdrawal
        : KServerHandler.bankDeposit;
    final response = await apiCall.call(
      bankID: bankID,
      bankName: bankName,
      bankAccount: accountNameCtrl.text,
      bankAccNumber: bankAccountNumberCtrl.text,
      amount: amountCtrl.text.isEmpty ? "0" : amountCtrl.text,
    );
    KSnackBarHelper.fromResponse(response);

    if (hasModifyBank) {
      await KSessionData.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final editButton = Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onSubmitClick,
        child: Text("Confirm"),
      ),
    );

    final bank = KProfileInput(
      heading: KPhrases.bank,
      headingWidth: 105,
      readOnly: true,
      customChild: KBankPicker(
        controller: this.bankCtrl,
        decoration: BoxDecoration(),
        height: 59,
      ),
    );

    final bankAccountName = KProfileInput(
      controller: accountNameCtrl,
      headingWidth: 105,
      readOnly: false,
      heading: KPhrases.accountName,
      hintText: KPhrases.accountNamePlaceHolder,
      isRequired: true,
    );

    final bankAccount = KProfileInput(
      keyboardType: TextInputType.number,
      controller: bankAccountNumberCtrl,
      headingWidth: 105,
      readOnly: false,
      heading: KPhrases.accountNumber,
      hintText: KPhrases.accountNumberPlaceHolder,
      isRequired: true,
    );

    final amount = KProfileInput(
      keyboardType: TextInputType.number,
      controller: amountCtrl,
      headingWidth: 105,
      readOnly: false,
      heading: '${KPhrases.amount} (${widget.tokenName})',
      hintText: KPhrases.amountPlaceHolder,
      isRequired: true,
    );

    final content = Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bank,
            bankAccountName,
            bankAccount,
            amount,
            SizedBox(height: 20),
            // FadeInImage(
            //   placeholder: AssetImage(Assets.IMG_TRANSPARENCY),
            //   image: AssetImage(KAssets.IMG_POWERED_BY_CHAO),
            //   height: 60,
            // ),
            // Text(
            //   "Powered by chao!",
            //   style: Theme.of(context)
            //       .textTheme
            //       .subtitle2!
            //       .copyWith(color: Theme.of(context).primaryColorLight),
            // ),
          ],
        ),
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Expanded(child: content),
        editButton,
      ],
    );

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide >= KStyles.smallestSize) return body;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.action == BankTransferAction.withdraw
            ? KPhrases.withdrawal
            : KPhrases.deposit),
      ),
      body: SafeArea(child: body),
    );
  }
}
