// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knotif_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNotifData _$KNotifDataFromJson(Map<String, dynamic> json) => KNotifData()
  ..title = json['title'] as String?
  ..body = json['body'] as String?;

Map<String, dynamic> _$KNotifDataToJson(KNotifData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('body', instance.body);
  return val;
}
