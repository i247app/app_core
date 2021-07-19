// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knotif_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNotifData _$KNotifDataFromJson(Map<String, dynamic> json) {
  return KNotifData()
    ..title = json['title'] as String?
    ..body = json['body'] as String?;
}

Map<String, dynamic> _$KNotifDataToJson(KNotifData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };
