import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kpasscode_helper.dart';
import 'package:app_core/model/knotice_data.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:app_core/ui/widget/kpasscode/kpasscode_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum KPasscodeAction { store, clear, login }

class KPasscode extends StatefulWidget {
  final KPasscodeAction action;
  final String? appBarTitle;
  final Function()? onReturn;

  KPasscode({
    required this.action,
    this.appBarTitle,
    this.onReturn,
  });

  @override
  State<StatefulWidget> createState() => _KPasscodeSettingState();
}

class _KPasscodeSettingState extends State<KPasscode> {
  final TextEditingController passcodeCtrl = TextEditingController();
  final TextEditingController rePasscodeCtrl = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final StreamController<bool> verificationNotifier =
      StreamController<bool>.broadcast();

  KNumberPadMode keyboardMode = KNumberPadMode.NUMBER;

  bool isShowRePasscodeInput = false;
  bool isLoading = false;
  String errorMessage = "";

  String get titleText => widget.action == KPasscodeAction.clear ||
          widget.action == KPasscodeAction.login
      ? KPhrases.inputCurrentPasscode
      : (isShowRePasscodeInput
          ? KPhrases.inputRePasscode
          : KPhrases.inputPasscode);

  @override
  void initState() {
    super.initState();

    passcodeCtrl.addListener(onTextUpdate);
    rePasscodeCtrl.addListener(onTextUpdate);
  }

  @override
  void dispose() {
    passcodeCtrl.removeListener(onTextUpdate);
    rePasscodeCtrl.removeListener(onTextUpdate);
    focusNode.dispose();
    verificationNotifier.close();
    super.dispose();
  }

  void onTextUpdate() {
    setState(() {});
  }

  void onPasscodeValid() async {
    if (widget.action == KPasscodeAction.login) {
      bool isMatch = await KPasscodeHelper.checkPasscode(passcodeCtrl.text);
      verificationNotifier.add(isMatch);

      if (isMatch) {
        if (widget.onReturn != null) {
          setState(() {
            keyboardMode = KNumberPadMode.NONE;
            isLoading = true;
          });
          try {
            await widget.onReturn!();
          } catch (ex) {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          errorMessage = KPhrases.passcodeNotMatch;
          passcodeCtrl.text = '';
        });
      }
    } else if (widget.action == KPasscodeAction.clear) {
      bool isMatch = await KPasscodeHelper.checkPasscode(passcodeCtrl.text);
      verificationNotifier.add(isMatch);

      if (isMatch) {
        await KPasscodeHelper.clearPasscode();
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          errorMessage = KPhrases.passcodeNotMatch;
          passcodeCtrl.text = '';
        });
      }
    } else if (isShowRePasscodeInput) {
      bool isMatch = passcodeCtrl.text == rePasscodeCtrl.text;
      verificationNotifier.add(isMatch);

      if (isMatch) {
        await KPasscodeHelper.storePasscode(passcodeCtrl.text);
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          errorMessage = KPhrases.passcodeNotMatch;
          isShowRePasscodeInput = false;
          passcodeCtrl.text = '';
          rePasscodeCtrl.text = '';
        });
      }
    } else {
      setState(() {
        isShowRePasscodeInput = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passcodeInput = KPasscodeInput(
      passcodeCtrl: passcodeCtrl,
      shouldTriggerVerification: verificationNotifier.stream,
    );

    final rePasscodeInput = KPasscodeInput(
      passcodeCtrl: rePasscodeCtrl,
      shouldTriggerVerification: verificationNotifier.stream,
    );

    final errorLabel = isLoading
        ? CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (KStringHelper.isExist(errorMessage))
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: KStyles.colorError,
                  ),
                ),
            ],
          );

    final upperContent = ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      children: [
        Text(
          titleText,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        Center(
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    if (keyboardMode != KNumberPadMode.NUMBER) {
                      setState(() {
                        keyboardMode = KNumberPadMode.NUMBER;
                      });
                    }
                  },
            child: isShowRePasscodeInput ? rePasscodeInput : passcodeInput,
          ),
        ),
        SizedBox(height: 14),
        Center(child: errorLabel),
      ],
    );

    final keyboard = KNumberPad(
      controller: isShowRePasscodeInput ? rePasscodeCtrl : passcodeCtrl,
      style: KNumberPadStyle.PASSCODE,
      onReturn: () {},
      maxLength: KPasscodeInput.PASSCODE_LENGTH,
      decimals: 0,
      onTextChange: (String passcode) {
        if (KStringHelper.isExist(errorMessage) &&
            KStringHelper.isExist(passcode)) {
          setState(() {
            errorMessage = "";
          });
        }
        if (ModalRoute.of(context)!.isCurrent &&
            passcode.length == KPasscodeInput.PASSCODE_LENGTH) {
          onPasscodeValid();
        }
      },
    );

    final body = Column(
      children: <Widget>[
        Expanded(child: upperContent),
        if (keyboardMode == KNumberPadMode.NUMBER) keyboard,
      ],
    );

    return Scaffold(
      appBar:
          AppBar(title: Text(widget.appBarTitle ?? KPhrases.passcodeSetting)),
      body: GestureDetector(
        onTap: () {
          if (keyboardMode == KNumberPadMode.NUMBER) {
            setState(() {
              keyboardMode = KNumberPadMode.NONE;
            });
          }
        },
        child: SafeArea(child: body),
      ),
    );
  }
}
