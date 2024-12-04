// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kflash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KFlash _$KFlashFromJson(Map<String, dynamic> json) => KFlash()
  ..flashType = json['flashType'] as String?
  ..mediaType = json['mediaType'] as String?
  ..media = json['media'] as String?
  ..nickName = json['nickName'] as String?;

Map<String, dynamic> _$KFlashToJson(KFlash instance) => <String, dynamic>{
      if (instance.flashType case final value?) 'flashType': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.media case final value?) 'media': value,
      if (instance.nickName case final value?) 'nickName': value,
    };
