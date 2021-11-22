import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';

part 'kapp_nav.g.dart';

// ignore: non_constant_identifier_names
int? zzz_appNavTryAtoi(dynamic num) {
  try {
    return zzz_atoi(num?.toString()) ?? KAppNav.OFF;
  } catch (e) {
    return KAppNav.OFF;
  }
}

@JsonSerializable()
class KAppNav {
  static const String STUDY_APP_MODE = "studyAppMode";
  static const String CLASS_APP_MODE = "classAppMode";
  static const String UNIVERSITY_APP_MODE = "uniAppMode";
  static const String GIG_APP_MODE = "gigAppMode";
  static const String CHAT_APP_MODE = "chatAppMode";
  static const String REWARD_APP_MODE = "rewardAppMode";
  static const String PAY_APP_MODE = "payAppMode";
  static const String AMP_APP_MODE = "ampAppMode";
  static const String SPLASH_MODE = "splashMode";

  static const int OFF = -1;
  static const int ON = 0;
  static const int READONLY = 1;

  @JsonKey(
    name: STUDY_APP_MODE,
    toJson: zzz_itoa,
    fromJson: zzz_appNavTryAtoi,
  )
  int? studyAppMode;

  @JsonKey(
    name: CLASS_APP_MODE,
    toJson: zzz_itoa,
    fromJson: zzz_appNavTryAtoi,
  )
  int? classAppMode;

  @JsonKey(
    name: UNIVERSITY_APP_MODE,
    toJson: zzz_itoa,
    fromJson: zzz_appNavTryAtoi,
  )
  int? universityAppMode;

  @JsonKey(name: GIG_APP_MODE, toJson: zzz_itoa, fromJson: zzz_appNavTryAtoi)
  int? gigAppMode;

  @JsonKey(name: CHAT_APP_MODE, toJson: zzz_itoa, fromJson: zzz_appNavTryAtoi)
  int? chatAppMode;

  @JsonKey(name: REWARD_APP_MODE, toJson: zzz_itoa, fromJson: zzz_appNavTryAtoi)
  int? rewardAppMode;

  @JsonKey(name: PAY_APP_MODE, toJson: zzz_itoa, fromJson: zzz_appNavTryAtoi)
  int? payAppMode;

  @JsonKey(name: AMP_APP_MODE, toJson: zzz_itoa, fromJson: zzz_appNavTryAtoi)
  int? ampAppMode;

  @JsonKey(name: SPLASH_MODE, toJson: zzz_itoa, fromJson: zzz_appNavTryAtoi)
  int? splashMode;

  // JSON
  KAppNav();

  factory KAppNav.fromJson(Map<String, dynamic> json) =>
      _$KAppNavFromJson(json);

  Map<String, dynamic> toJson() => _$KAppNavToJson(this);
}
