import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:slider_captcha/slider_captcha.dart';

class KImageCaptcha extends StatefulWidget {
  final Function? onVerified;
  final String label;

  const KImageCaptcha({this.onVerified, required this.label});

  @override
  State<StatefulWidget> createState() => _KImageCaptchaState();
}

class _KImageCaptchaState extends State<KImageCaptcha> {
  final SliderController captchaController = SliderController();

  String? captchaBackground;
  static const List<String> BACKGROUND_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];

  @override
  void initState() {
    super.initState();

    this.captchaBackground = ([...BACKGROUND_IMAGES]..shuffle()).first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reloadCaptcha() {
    captchaController.create();
    this.setState(() {
      this.captchaBackground = ([...BACKGROUND_IMAGES.where((image) => image != this.captchaBackground)]..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (captchaBackground == null) return Container();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: SliderCaptcha(
        controller: captchaController,
        image: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            captchaBackground!,
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
            package: 'app_core',
          ),
        ),
        colorBar: Colors.orange,
        colorCaptChar: Colors.orange,
        title: widget.label,
        onConfirm: (value) {
          if (value) {
            return Future.delayed(const Duration(seconds: 0)).then(
              (value) {
                if (widget.onVerified != null) widget.onVerified!();
              },
            );
          } else {
            return Future.delayed(const Duration(milliseconds: 250)).then(
              (value) {
                this.reloadCaptcha();
              },
            );
          }
        },
      ),
    );
  }
}
