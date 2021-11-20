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

Map<String, dynamic> _$KFlashToJson(KFlash instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('flashType', instance.flashType);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('media', instance.media);
  writeNotNull('nickName', instance.nickName);
  return val;
}
