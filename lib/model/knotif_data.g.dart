// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knotif_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNotifData _$KNotifDataFromJson(Map<String, dynamic> json) => KNotifData()
  ..title = json['title'] as String?
  ..body = json['body'] as String?;

Map<String, dynamic> _$KNotifDataToJson(KNotifData instance) =>
    <String, dynamic>{
      if (instance.title case final value?) 'title': value,
      if (instance.body case final value?) 'body': value,
    };
