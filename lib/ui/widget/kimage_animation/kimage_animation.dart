import 'dart:math';

import 'package:app_core/ui/widget/kimage_animation/animations/shake_the_top.dart';
import 'package:app_core/ui/widget/kimage_animation/animations/tiny_zoom_shake.dart';
import 'package:app_core/ui/widget/kimage_animation/animations/zoom_bounce.dart';
import 'package:app_core/ui/widget/kimage_animation/animations/zoom_shake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/model/kimage_animation_parameters.dart';
import 'package:app_core/helper/kimage_animation_helper.dart';

import 'animations/cross_left_to_right_jumper.dart';
import 'animations/cross_right_to_left.dart';
import 'animations/cross_left_to_right.dart';
import 'animations/cross_left_to_right_stop_jumper.dart';
import 'animations/drop_bounce_image.dart';
import 'animations/drop_bounce_shake.dart';
import 'animations/shake_image.dart';

class KImageAnimationType {
  static const String TINY_ZOOM_SHAKE = "TINY_ZOOM_SHAKE";
  static const String DROP_BOUNCE = "DROP_BOUNCE";
  static const String HORIZONTAL = "HORIZONTAL";
  static const String DROP_BOUNCE_SHAKE_RANDOM = "DROP_BOUNCE_SHAKE_RANDOM";
  static const String DROP_BOUNCE_SHAKE_HORIZONTAL =
      "DROP_BOUNCE_SHAKE_HORIZONTAL";
  static const String SCREEN_RIGHT_LEFT = "SCREEN_RIGHT_LEFT";
  static const String SCREEN_LEFT_RIGHT = "SCREEN_LEFT_RIGHT";
  static const String SCREEN_LEFT_RIGHT_JUMP = "SCREEN_LEFT_RIGHT_JUMP";
  static const String SCREEN_LEFT_RIGHT_STOP_JUMP =
      "SCREEN_LEFT_RIGHT_STOP_JUMP";
  static const String ZOOM_BOUNCE =
      "ZOOM_BOUNCE";
  static const String ZOOM_SHAKE =
      "ZOOM_SHAKE";
  static const String SHAKE_THE_TOP =
      "SHAKE_THE_TOP";

  static const List<String> animationList = [
    DROP_BOUNCE,
    HORIZONTAL,
    DROP_BOUNCE_SHAKE_RANDOM,
    DROP_BOUNCE_SHAKE_HORIZONTAL,
    SCREEN_RIGHT_LEFT,
    SCREEN_LEFT_RIGHT,
    SCREEN_LEFT_RIGHT_JUMP,
    SCREEN_LEFT_RIGHT_STOP_JUMP,
    ZOOM_BOUNCE,
    ZOOM_SHAKE,
    SHAKE_THE_TOP,
  ];

  static String get randomAnimationType =>
      animationList[Random().nextInt(animationList.length)];
}

class KImageAnimation extends StatefulWidget {
  final String animationType;
  final List<String> imageUrls;
  final int? maxLoop;
  final double? size;
  final bool? isAssetImage;
  final Function? onFinish;

  const KImageAnimation({
    required this.animationType,
    required this.imageUrls,
    this.isAssetImage,
    this.onFinish,
    this.maxLoop,
    this.size,
  });

  @override
  _KImageAnimationState createState() => _KImageAnimationState();
}

class _KImageAnimationState extends State<KImageAnimation> {
  Widget getAnimationBody() {
    switch (widget.animationType) {
      case KImageAnimationType.DROP_BOUNCE:
        return DropBounceImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.HORIZONTAL:
        return ShakeImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: true,
            isRandom: false,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.DROP_BOUNCE_SHAKE_RANDOM:
        return DropBounceShakeImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: false,
            isRandom: true,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.DROP_BOUNCE_SHAKE_HORIZONTAL:
        return DropBounceShakeImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: true,
            isRandom: false,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.SCREEN_RIGHT_LEFT:
        return CrossRightToLeftImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: true,
            isRandom: false,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.SCREEN_LEFT_RIGHT:
        return CrossLeftToRightImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: true,
            isRandom: false,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.SCREEN_LEFT_RIGHT_JUMP:
        return CrossLeftToRightJumperImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: true,
            isRandom: false,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.SCREEN_LEFT_RIGHT_STOP_JUMP:
        return CrossLeftToRightStopJumperImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            speed: 10,
            isHorizontal: true,
            isRandom: false,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.ZOOM_BOUNCE:
        return ZoomBounceImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.ZOOM_SHAKE:
        return ZoomShakeImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.TINY_ZOOM_SHAKE:
        return TinyZoomShakeImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      case KImageAnimationType.SHAKE_THE_TOP:
        return ShakeTheTopImage(
          widget.imageUrls.length > 0
              ? widget.imageUrls
              : KImageAnimationHelper.animationImages,
          animationPreset: KImageAnimationParameters(
            size: widget.size,
            maxLoop: widget.maxLoop ?? 0,
            onFinish: widget.onFinish,
            isAssetImage: widget.isAssetImage,
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = getAnimationBody();
    return body;
  }
}
