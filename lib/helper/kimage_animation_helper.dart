import 'dart:math';

import 'package:app_core/model/kimage_animation_parameters.dart';

abstract class KImageAnimationHelper {
  static final animationImages = [
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/schoolfairy.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/greenball.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/mangosteen.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/bento.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/hasu.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/ichigo.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/pho_wakame.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/tofu_chan.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/duriman.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/midori.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/ryu.png",
    "https://bird-pub.s3.us-west-1.amazonaws.com/hero/yosei.png",
  ];

  static final animationPresets = [
    KImageAnimationParameters(
      key: 'SLOW_HORIZONTAL_SHAKE',
      speed: 5,
      isHorizontal: true,
      isRandom: false,
      maxLoop: 0,
    ),
    KImageAnimationParameters(
      key: 'FAST_HORIZONTAL_SHAKE',
      speed: 20,
      isHorizontal: true,
      isRandom: false,
      maxLoop: 0,
    ),
    KImageAnimationParameters(
      key: 'SLOW_RANDOM_SHAKE',
      speed: 5,
      isHorizontal: false,
      isRandom: true,
      maxLoop: 0,
    ),
    KImageAnimationParameters(
      key: 'FAST_RANDOM_SHAKE',
      speed: 10,
      isHorizontal: false,
      isRandom: true,
      maxLoop: 0,
    ),
  ];

  static String get randomImage =>
      animationImages[Random().nextInt(animationImages.length)];

  static KImageAnimationParameters get randomPreset =>
      animationPresets[Random().nextInt(animationPresets.length)];
}
