import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KLottie extends StatelessWidget {
  final String url;
  final String errorAsset;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const KLottie({
    Key? key,
    required this.url,
    this.errorAsset = "assets/animation/connection_error.json",
    this.fit,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      this.url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Lottie.asset(
        this.errorAsset,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
