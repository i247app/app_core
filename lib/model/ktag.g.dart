// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ktag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KTag _$KTagFromJson(Map<String, dynamic> json) => KTag()
  ..tagID = json['tagID'] as String?
  ..groupIndex = json['groupIndex'] as String?
  ..groupName = json['groupName'] as String?
  ..groupIcon = json['groupIcon'] as String?
  ..tagIndex = json['tagIndex'] as String?
  ..tagName = json['tagName'] as String?
  ..tagIcon = json['tagIcon'] as String?
  ..tagStatus = json['tagStatus'] as String?;

Map<String, dynamic> _$KTagToJson(KTag instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tagID', instance.tagID);
  writeNotNull('groupIndex', instance.groupIndex);
  writeNotNull('groupName', instance.groupName);
  writeNotNull('groupIcon', instance.groupIcon);
  writeNotNull('tagIndex', instance.tagIndex);
  writeNotNull('tagName', instance.tagName);
  writeNotNull('tagIcon', instance.tagIcon);
  writeNotNull('tagStatus', instance.tagStatus);
  return val;
}
