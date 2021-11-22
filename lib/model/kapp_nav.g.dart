// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapp_nav.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KAppNav _$KAppNavFromJson(Map<String, dynamic> json) => KAppNav()
  ..studyAppMode = zzz_appNavTryAtoi(json['studyAppMode'])
  ..classAppMode = zzz_appNavTryAtoi(json['classAppMode'])
  ..universityAppMode = zzz_appNavTryAtoi(json['uniAppMode'])
  ..gigAppMode = zzz_appNavTryAtoi(json['gigAppMode'])
  ..chatAppMode = zzz_appNavTryAtoi(json['chatAppMode'])
  ..rewardAppMode = zzz_appNavTryAtoi(json['rewardAppMode'])
  ..payAppMode = zzz_appNavTryAtoi(json['payAppMode'])
  ..ampAppMode = zzz_appNavTryAtoi(json['ampAppMode'])
  ..splashMode = zzz_appNavTryAtoi(json['splashMode']);

Map<String, dynamic> _$KAppNavToJson(KAppNav instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('studyAppMode', zzz_itoa(instance.studyAppMode));
  writeNotNull('classAppMode', zzz_itoa(instance.classAppMode));
  writeNotNull('uniAppMode', zzz_itoa(instance.universityAppMode));
  writeNotNull('gigAppMode', zzz_itoa(instance.gigAppMode));
  writeNotNull('chatAppMode', zzz_itoa(instance.chatAppMode));
  writeNotNull('rewardAppMode', zzz_itoa(instance.rewardAppMode));
  writeNotNull('payAppMode', zzz_itoa(instance.payAppMode));
  writeNotNull('ampAppMode', zzz_itoa(instance.ampAppMode));
  writeNotNull('splashMode', zzz_itoa(instance.splashMode));
  return val;
}
