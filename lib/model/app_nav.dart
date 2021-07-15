import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/response/base_response.dart';

// ignore: non_constant_identifier_names
int? zzz_tryatoi(dynamic num) {
  try {
    if (num is bool) {
      return zzz_atoi(num ? "0" : "-1");
    }

    return zzz_atoi(num?.toString() ?? "-1");
  } catch (e) {
    return -1;
  }
}

class KAppNavStatus {
  static const int OFF = -1;
  static const int ON = 0;
  static const int READONLY = 1;
}

class KAppNav {
  static const String SPLASH_MODE = "splashMode";

  @JsonKey(name: SPLASH_MODE, toJson: zzz_itoa, fromJson: zzz_tryatoi)
  int? splashMode;
}
