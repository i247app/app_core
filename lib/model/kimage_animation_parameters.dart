class KImageAnimationParameters {
  String? key;
  double? speed;
  bool? isRandom;
  bool? isHorizontal;
  bool? isAssetImage;
  double? size;
  int? maxLoop;
  Function? onFinish;

  KImageAnimationParameters({
    this.key,
    this.speed,
    this.isHorizontal,
    this.isRandom,
    this.isAssetImage,
    this.size,
    this.maxLoop,
    this.onFinish,
  });
}
