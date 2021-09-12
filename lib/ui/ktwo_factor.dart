import 'package:app_core/app_core.dart';
import 'package:app_core/model/knotice_data.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:app_core/ui/widget/knumber_pad.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';

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

class _KTwoFactorState extends State<KTwoFactor> with CodeAutoFill {
  static const int KEYBOARD_MODE_NONE = 0;
  static const int KEYBOARD_MODE_NUMBER = 1;

  final TextEditingController pinController = TextEditingController();
  final SmsAutoFill smsAutoFill = SmsAutoFill();

  String? responseKpin;
  KNoticeData? notice;

  FocusNode focusNode = FocusNode();
  int keyboardMode = KEYBOARD_MODE_NUMBER;
  bool sendCodeEnabled = true;

  bool get shouldAutoSendPin => true;

  @override
  void initState() {
    super.initState();

    // Listen for 2FA pin
    listenForCode();

    // Print the app signature
    this
        .smsAutoFill
        .getAppSignature
        .then((sig) => KServerHandler.logToServer("appSignature", sig));

    // Auto send code if requested
    if (this.shouldAutoSendPin) Future.delayed(Duration(seconds: 1), sendCode);
  }

  @override
  void dispose() {
    this.focusNode.dispose();
    cancel();
    this.smsAutoFill.unregisterListener();
    super.dispose();
  }

  @override
  void codeUpdated() {
    if (KStringHelper.isExist(this.code ?? "")) {
      print("######### CODE - $code");
      setState(() => this.pinController.text = (this.code ?? ""));
    }
  }

  void sendCode() async {
    setState(() {
      this.notice = null;
      this.responseKpin = null;
    });

    final isAllowed = await Permission.notification.isGranted;
    if (isAllowed) {
      PermissionStatus status = await Permission.notification.request();
      if (status != PermissionStatus.granted) print("Permissions denied");
    }

    final response = await KServerHandler.send2FACode(
      phone: widget.phone,
      email: widget.email,
    );
    if (response.kstatus == 100) {
      setState(() {
        this.notice = KNoticeData.success("");
        this.responseKpin = response.kpin;
        this.sendCodeEnabled = false;
      });

      Future.delayed(
        Duration(seconds: 30),
        () => mounted ? setState(() => this.sendCodeEnabled = true) : null,
      );
    } else {
      setState(() =>
          this.notice = KNoticeData.error("Failed to send security code."));
    }

    await smsAutoFill.listenForCode;
  }

  void submit(String kpin) async {
    setState(() => this.notice = null);

    switch (widget.behavior) {
      case KTwoFactorBehavior.legacy:
        legacySubmit(kpin);
        break;
      case KTwoFactorBehavior.passBackPin:
        passPinToParentScreen(kpin);
        break;
    }

    this.focusNode.requestFocus();
  }

  void legacySubmit(String kpin) async {
    final response = await KServerHandler.verify2FACode(kpin);
    if (response.kstatus == 100)
      Navigator.of(context).pop(kpin);
    else if (response.kstatus == 415) {
      setState(() {
        this.pinController.clear();
        this.responseKpin = null;
        this.notice =
            KNoticeData.error(response.kmessage ?? "Security Code Expired");
      });
    } else {
      setState(() {
        this.pinController.clear();
        this.responseKpin = null;
        this.notice =
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
      showCursor: keyboardMode == KEYBOARD_MODE_NUMBER,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30, letterSpacing: 10),
      maxLength: KTwoFactor.PIN_LENGTH,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onTap: () {
        if (keyboardMode != KEYBOARD_MODE_NUMBER) {
          this.setState(() {
            this.keyboardMode = KEYBOARD_MODE_NUMBER;
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
      onPressed: this.sendCodeEnabled ? sendCode : null,
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          color:
              this.sendCodeEnabled ? KStyles.colorSecondary : KStyles.lightGrey,
        ),
      ),
      child: Text("Resend Code"),
    );

    final errorLabel = this.notice == null && this.responseKpin == null
        ? CircularProgressIndicator()
        : this.responseKpin == null
            ? Text(
                this.notice?.message ?? "An error occurred",
                style: TextStyle(
                  color: this.notice?.isSuccess ?? false
                      ? KStyles.darkGrey
                      : KStyles.colorError,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pin",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 6),
                  Text(
                    this.responseKpin ?? "",
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.normal,
                      color: KStyles.colorSecondary,
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
      controller: this.pinController,
      onReturn: () {},
      onTextChange: (pin) {
        if (pin.length == KTwoFactor.PIN_LENGTH &&
            ModalRoute.of(context)!.isCurrent) {
          submit(pin);
        }
      },
    );

    final body = Column(children: <Widget>[
      Expanded(child: upperContent),
      if (keyboardMode == KEYBOARD_MODE_NUMBER) keyboard,
    ]);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Security"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
          onTap: () {
            if (keyboardMode == KEYBOARD_MODE_NUMBER) {
              this.setState(() {
                this.keyboardMode = KEYBOARD_MODE_NONE;
              });
            }
          },
          child: SafeArea(child: body)),
    );
  }
}
