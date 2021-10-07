class KImageAnimationParameters {
  String? key;
  double? speed;
  bool? isRandom;
  bool? isHorizontal;
  int? maxLoop;
  Function? onFinish;

  KImageAnimationParameters({
    this.key,
    this.speed,
    this.isHorizontal,
    this.isRandom,
    this.maxLoop,
    this.onFinish,
  });
}
