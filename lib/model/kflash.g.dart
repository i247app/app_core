// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kflash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KFlash _$KFlashFromJson(Map<String, dynamic> json) {
  return KFlash()
    ..flashType = json['flashType'] as String?
    ..mediaType = json['mediaType'] as String?
    ..media = json['media'] as String?
    ..nickName = json['nickName'] as String?;
}

Map<String, dynamic> _$KFlashToJson(KFlash instance) => <String, dynamic>{
      'flashType': instance.flashType,
      'mediaType': instance.mediaType,
      'media': instance.media,
      'nickName': instance.nickName,
    };
