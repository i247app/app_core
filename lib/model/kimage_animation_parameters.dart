class KImageAnimationParameters {
  String? key;
  double? speed;
  bool? isRandom;
  bool? isHorizontal;
  double? size;
  int? maxLoop;
  Function? onFinish;

  KImageAnimationParameters({
    this.key,
    this.speed,
    this.isHorizontal,
    this.isRandom,
    this.size,
    this.maxLoop,
    this.onFinish,
  });
}
