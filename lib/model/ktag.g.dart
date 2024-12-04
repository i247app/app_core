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

Map<String, dynamic> _$KTagToJson(KTag instance) => <String, dynamic>{
      if (instance.tagID case final value?) 'tagID': value,
      if (instance.groupIndex case final value?) 'groupIndex': value,
      if (instance.groupName case final value?) 'groupName': value,
      if (instance.groupIcon case final value?) 'groupIcon': value,
      if (instance.tagIndex case final value?) 'tagIndex': value,
      if (instance.tagName case final value?) 'tagName': value,
      if (instance.tagIcon case final value?) 'tagIcon': value,
      if (instance.tagStatus case final value?) 'tagStatus': value,
    };
