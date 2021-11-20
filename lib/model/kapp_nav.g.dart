// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapp_nav.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KAppNav _$KAppNavFromJson(Map<String, dynamic> json) =>
    KAppNav()..splashMode = zzz_tryatoi(json['splashMode']);

Map<String, dynamic> _$KAppNavToJson(KAppNav instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('splashMode', zzz_itoa(instance.splashMode));
  return val;
}
