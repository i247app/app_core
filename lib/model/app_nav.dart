import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/response/base_response.dart';


// ignore: non_constant_identifier_names
int? zzz_tryatoi(dynamic? num) {
  try {
    if (num is bool) {
      return zzz_atoi(num ? "0" : "-1");
    }

    return zzz_atoi(num?.toString() ?? "-1");
  } catch (e) {
    return -1;
  }
}

@JsonSerializable()
class AppCoreAppNav {
  static const String SPLASH_MODE = "splashMode";

  int OFF = -1;
  int ON = 0;
  int READONLY = 1;

  @JsonKey(name: SPLASH_MODE, toJson: zzz_itoa, fromJson: zzz_tryatoi)
  int? splashMode;

  // JSON
  AppCoreAppNav();
}
