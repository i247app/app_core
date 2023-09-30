import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kpasscode_helper.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:app_core/ui/widget/kpasscode/kpasscode_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum KPasscodeAction { store, clear, login }

class KPasscode extends StatefulWidget {
  final bool isEmbedded;
  final KPasscodeAction action;
  final String? appBarTitle;
  final Function(bool isSuccess)? onReturn;

  KPasscode({
    required this.action,
    this.appBarTitle,
    this.onReturn,
    this.isEmbedded = false,
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

  bool isShowRePasscodeInput = false;
  bool isLoading = false;
  String errorMessage = "";

  String get titleText {
    switch (widget.action) {
      case KPasscodeAction.clear:
        return KPhrases.inputCurrentPasscode;
      case KPasscodeAction.login:
        return KPhrases.enterLoginPin;
      case KPasscodeAction.store:
      default:
        return isShowRePasscodeInput
            ? KPhrases.inputRePasscode
            : KPhrases.inputPasscode;
    }
  }

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
            isLoading = true;
          });
          try {
            await widget.onReturn!(true);
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

  onKeyboardButtonPressed(String text) {
    if (isLoading) return;

    final currentCtrl = isShowRePasscodeInput ? rePasscodeCtrl : passcodeCtrl;
    final currentText = currentCtrl.text;

    if (text == _Keyboard.CANCEL_BUTTON) {
      if (widget.onReturn != null) {
        widget.onReturn!(false);
      } else {
        Navigator.of(context).pop();
      }
      return;
    }

    if (text == _Keyboard.DELETE_BUTTON) {
      if (currentText.length > 0) {
        final newText = currentText.substring(0, currentText.length - 1);
        currentCtrl.text = newText;
      }
      return;
    }

    if (currentText.length >= KPasscodeInput.PASSCODE_LENGTH) {
      return;
    }

    if (KStringHelper.isExist(errorMessage) && KStringHelper.isExist(text)) {
      setState(() {
        errorMessage = "";
      });
    }

    final newText = '${currentText}${text}';
    currentCtrl.text = newText;
    if (newText.length == KPasscodeInput.PASSCODE_LENGTH) {
      onPasscodeValid();
    }
  }

  buildKeyboard() => Container(
        child: _Keyboard(
          onKeyboardTap: onKeyboardButtonPressed,
          primaryColor: Theme.of(context).colorScheme.onBackground,
          digitTextStyle: TextStyle(
            fontSize: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          deleteButtonTextStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );

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

    final keyboard = buildKeyboard();

    final body = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        children: <Widget>[
          Text(
            titleText,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          Center(
            child: isShowRePasscodeInput ? rePasscodeInput : passcodeInput,
          ),
          SizedBox(height: 14),
          Center(child: errorLabel),
          SizedBox(height: 20),
          keyboard,
        ],
      ),
    );

    if (widget.isEmbedded) return body;

    return Scaffold(
      appBar:
          AppBar(title: Text(widget.appBarTitle ?? KPhrases.passcodeSetting)),
      body: SafeArea(child: body),
    );
  }
}

class _Keyboard extends StatelessWidget {
  static String DELETE_BUTTON = 'keyboard_delete_button';
  static String CANCEL_BUTTON = 'keyboard_cancel_button';

  final Function(String text) onKeyboardTap;
  final _focusNode = FocusNode();
  final double digitBorderWidth;
  final TextStyle digitTextStyle;
  final TextStyle deleteButtonTextStyle;
  final Color primaryColor;
  final Color digitFillColor;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry digitInnerMargin;

  //Size for the keyboard can be define and provided from the app.
  //If it will not be provided the size will be adjusted to a screen size.
  final Size? keyboardSize;

  //should have a proper order [1...9, 0]
  final List<String>? digits;

  _Keyboard({
    Key? key,
    required this.onKeyboardTap,
    this.digits,
    this.digitBorderWidth = 1,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15, left: 4, right: 4),
    this.digitInnerMargin = const EdgeInsets.all(24),
    this.primaryColor = Colors.white,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.white),
    this.deleteButtonTextStyle =
        const TextStyle(fontSize: 16, color: Colors.white),
    this.keyboardSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard(context);

  Widget _buildKeyboard(BuildContext context) {
    List<String> keyboardItems = List.filled(10, '0');
    if (digits == null || digits!.isEmpty) {
      keyboardItems = [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        _Keyboard.CANCEL_BUTTON,
        '0',
        _Keyboard.DELETE_BUTTON,
      ];
    } else {
      keyboardItems = digits!;
    }
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width
        ? screenSize.height / 2
        : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    final keyboardSize = this.keyboardSize != null
        ? this.keyboardSize!
        : Size(keyboardWidth, keyboardHeight);
    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: EdgeInsets.only(top: 16),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyUpEvent) {
            if (keyboardItems.contains(event.data.keyLabel)) {
              onKeyboardTap(event.logicalKey.keyLabel);
              return;
            }
            if (event.logicalKey.keyLabel == 'Backspace' ||
                event.logicalKey.keyLabel == 'Delete') {
              onKeyboardTap(_Keyboard.DELETE_BUTTON);
              return;
            }
          }
        },
        child: _AlignedGrid(
          keyboardSize: keyboardSize,
          children: List.generate(keyboardItems.length, (index) {
            return _buildKeyboardDigit(keyboardItems[index]);
          }),
        ),
      ),
    );
  }

  Widget _buildKeyboardDigit(String text) {
    if (text == _Keyboard.CANCEL_BUTTON) {
      return Container();
      // return Container(
      //   margin: EdgeInsets.all(4),
      //   child: InkWell(
      //     splashColor: this.primaryColor.withOpacity(0.4),
      //     onTap: () {
      //       onKeyboardTap(text);
      //     },
      //     child: Container(
      //       padding: EdgeInsets.symmetric(horizontal: 20),
      //       child: FittedBox(
      //         fit: BoxFit.scaleDown,
      //         alignment: Alignment.center,
      //         child: Text(
      //           KPhrases.cancel,
      //           style: this.digitTextStyle,
      //           semanticsLabel: text,
      //         ),
      //       ),
      //     ),
      //   ),
      // );
    }

    if (text == _Keyboard.DELETE_BUTTON) {
      return Container(
        margin: EdgeInsets.all(4),
        child: InkWell(
          splashColor: this.primaryColor.withOpacity(0.4),
          onTap: () {
            onKeyboardTap(text);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: this.digitFillColor,
            ),
            child: Center(
              child: Icon(Icons.backspace_outlined),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(4),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: this.primaryColor.withOpacity(0.4),
            onTap: () {
              onKeyboardTap(text);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: this.primaryColor, width: this.digitBorderWidth),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: this.digitFillColor,
                ),
                child: Center(
                  child: Text(
                    text,
                    style: this.digitTextStyle,
                    semanticsLabel: text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlignedGrid extends StatelessWidget {
  final double runSpacing = 4;
  final double spacing = 4;
  final int listSize;
  final columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  const _AlignedGrid({
    Key? key,
    required this.children,
    required this.keyboardSize,
  })  : listSize = children.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height
        ? keyboardSize.height
        : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: children
          .map((item) => Container(
                width: itemSize,
                height: itemSize,
                child: item,
              ))
          .toList(growable: false),
    );
  }
}
