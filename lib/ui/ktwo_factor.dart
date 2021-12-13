import 'package:app_core/app_core.dart';
import 'package:app_core/model/knotice_data.dart';
import 'package:app_core/helper/kserver_handler.dart';
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
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  String? responseKpin;
  KNoticeData? notice;

  KNumberPadMode keyboardMode = KNumberPadMode.NUMBER;
  bool sendCodeEnabled = true;

  bool get shouldAutoSendPin => true;

  @override
  void initState() {
    super.initState();

    // Auto send code if requested
    if (shouldAutoSendPin) Future.delayed(Duration(seconds: 1), sendCode);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void sendCode() async {
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
      });

      Future.delayed(
        Duration(seconds: 30),
        () => mounted ? setState(() => sendCodeEnabled = true) : null,
      );
    } else {
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
    final response = await KServerHandler.verify2FACode(kpin);
    if (response.kstatus == 100) {
      Navigator.of(context).pop(kpin);
    } else if (response.kstatus == 415) {
      setState(() {
        pinController.clear();
        responseKpin = null;
        notice =
            KNoticeData.error(response.kmessage ?? "Security Code Expired");
      });
    } else {
      setState(() {
        pinController.clear();
        responseKpin = null;
        notice =
            KNoticeData.error(response.kmessage ?? "Invalid Security Code");
      });
    }
  }

  void passPinToParentScreen(String kpin) => Navigator.of(context).pop(kpin);

  @override
  Widget build(BuildContext context) {
    final rawPinEdit = TextField(
      controller: pinController,
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
      child: Text("Resend Code"),
    );

    final errorLabel = notice == null && responseKpin == null
        ? CircularProgressIndicator()
        : responseKpin == null
            ? Text(
                notice?.message ?? "An error occurred",
                style: TextStyle(
                  color: notice?.isSuccess ?? false
                      ? KStyles.darkGrey
                      : KStyles.colorError,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Pin", style: TextStyle(fontSize: 30)),
                  SizedBox(height: 6),
                  Text(
                    responseKpin ?? "",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
      controller: pinController,
      onReturn: () {},
      onTextChange: (pin) {
        if (pin.length == KTwoFactor.PIN_LENGTH &&
            ModalRoute.of(context)!.isCurrent) {
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
