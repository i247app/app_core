import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/model/knotice_data.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum KTwoFactorBehavior { legacy, passBackPin }

class KTwoFactor extends StatefulWidget {
  static const int PIN_LENGTH = 4;

  final KTwoFactorBehavior behavior;
  final String? phone;
  final String? email;

  KTwoFactor({
    required this.behavior,
    this.phone,
    this.email,
  });

  @override
  State<StatefulWidget> createState() => _KTwoFactorState();
}

class _KTwoFactorState extends State<KTwoFactor> {
  final Duration resendCodeCooldown = Duration(seconds: 30);

  final TextEditingController pinCtrl = TextEditingController();
  final FocusNode focusNode = FocusNode();

  String? responseKpin;
  KNoticeData? notice;
  DateTime? lastSendCodeDate;
  Timer? timer;

  KNumberPadMode keyboardMode = KNumberPadMode.NUMBER;
  bool sendCodeEnabled = true;

  bool get shouldAutoSendPin => true;

  String get resendCodeLabel {
    final baseLabel = KPhrases.resendCode;
    final now = DateTime.now();
    if (lastSendCodeDate != null) {
      final durSinceLastSend = now.difference(lastSendCodeDate!);
      final timeLeftUntilCooldownOver = resendCodeCooldown - durSinceLastSend;
      if (timeLeftUntilCooldownOver.inSeconds > 0) {
        return "${timeLeftUntilCooldownOver.inSeconds} - $baseLabel";
      } else {
        return baseLabel;
      }
    } else {
      return baseLabel;
    }
  }

  @override
  void initState() {
    super.initState();

    // Auto send code if requested
    if (shouldAutoSendPin) Future.delayed(Duration(seconds: 1), sendCode);
  }

  @override
  void dispose() {
    timer?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void sendCode() async {
    try {
      setState(() {
        notice = null;
        responseKpin = null;
      });

      final isAllowed = await Permission.notification.isGranted;
      if (isAllowed) {
        final status = await Permission.notification.request();
        if (status != PermissionStatus.granted) print("Permissions denied");
      }

      final response = await KServerHandler.send2FACode(
        phone: widget.phone,
        email: widget.email,
      );

      if (response.isSuccess) {
        setState(() {
          notice = KNoticeData.success("");
          responseKpin = response.kpin;
          sendCodeEnabled = false;
          lastSendCodeDate = DateTime.now();
        });

        timer = Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            if (lastSendCodeDate == null) return;

            setState(() {});

            final now = DateTime.now();
            if (lastSendCodeDate!.isBefore(now.subtract(resendCodeCooldown))) {
              if (mounted) setState(() => sendCodeEnabled = true);
              timer.cancel();
            }
          },
        );
      } else {
        setState(
            () => notice = KNoticeData.error("Failed to send security code."));
      }
    } catch (ex) {
      setState(
          () => notice = KNoticeData.error("Failed to send security code."));
    }
  }

  void submit(String kpin) async {
    setState(() => notice = null);

    switch (widget.behavior) {
      case KTwoFactorBehavior.legacy:
        legacySubmit(kpin);
        break;
      case KTwoFactorBehavior.passBackPin:
        passPinToParentScreen(kpin);
        break;
    }

    focusNode.requestFocus();
  }

  void legacySubmit(String kpin) async {
    try {
      final response = await KServerHandler.verify2FACode(kpin);
      if (response.isSuccess) {
        Navigator.of(context).pop(kpin);
      } else if (response.kstatus == 415) {
        setState(() {
          keyboardMode = KNumberPadMode.NUMBER;
          pinCtrl.clear();
          // responseKpin = null;
          notice =
              KNoticeData.error(response.kmessage ?? "Security Code Expired");
        });
      } else {
        setState(() {
          keyboardMode = KNumberPadMode.NUMBER;
          pinCtrl.clear();
          // responseKpin = null;
          notice =
              KNoticeData.error(response.kmessage ?? "Invalid Security Code");
        });
      }
    } catch (ex) {
      setState(
          () => notice = KNoticeData.error("Failed to send security code."));
    }
  }

  void passPinToParentScreen(String kpin) => Navigator.of(context).pop(kpin);

  @override
  Widget build(BuildContext context) {
    final rawPinEdit = TextField(
      controller: pinCtrl,
      autofocus: true,
      readOnly: true,
      showCursor: keyboardMode == KNumberPadMode.NUMBER,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30, letterSpacing: 10),
      maxLength: KTwoFactor.PIN_LENGTH,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onTap: () {
        if (keyboardMode != KNumberPadMode.NUMBER) {
          setState(() {
            keyboardMode = KNumberPadMode.NUMBER;
          });
        }
      },
      decoration: InputDecoration(
        hintText: "Security Pin",
        hintStyle: TextStyle(letterSpacing: 1, fontSize: 16),
      ),
    );

    final pinEdit = Container(width: 140, child: rawPinEdit);

    final resendCodeButton = TextButton(
      onPressed: sendCodeEnabled ? sendCode : null,
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          color: sendCodeEnabled ? KStyles.colorSecondary : KStyles.lightGrey,
        ),
      ),
      child: Text(resendCodeLabel),
    );

    final errorLabel = notice == null && responseKpin == null
        ? CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if ((notice?.message ?? "").isNotEmpty)
                Text(
                  notice?.message ?? "An error occurred",
                  style: TextStyle(
                    color: notice?.isSuccess ?? false
                        ? KStyles.darkGrey
                        : KStyles.colorError,
                  ),
                ),
              if (responseKpin != null) ...[
                SizedBox(height: 10),
                Text("Pin", style: TextStyle(fontSize: 30)),
                SizedBox(height: 2),
                Text(
                  responseKpin ?? "",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ],
          );

    final upperContent = ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      children: [
        Center(child: pinEdit),
        SizedBox(height: 14),
        Center(child: errorLabel),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [resendCodeButton],
        ),
      ],
    );

    final keyboard = KNumberPad(
      controller: pinCtrl,
      onReturn: () {},
      onTextChange: (pin) {
        if (pin.length == KTwoFactor.PIN_LENGTH &&
            ModalRoute.of(context)!.isCurrent) {
          setState(() {
            keyboardMode = KNumberPadMode.NONE;
          });
          submit(pin);
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
      appBar: AppBar(title: Text("Security")),
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
