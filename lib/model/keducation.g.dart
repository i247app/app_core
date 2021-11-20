// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keducation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KEducation _$KEducationFromJson(Map<String, dynamic> json) => KEducation()
  ..id = json['educationID'] as String?
  ..puid = json['puid'] as String?
  ..schoolName = json['schoolName'] as String?
  ..degree = json['degree'] as String?
  ..year = json['year'] as String?;

Map<String, dynamic> _$KEducationToJson(KEducation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('educationID', instance.id);
  writeNotNull('puid', instance.puid);
  writeNotNull('schoolName', instance.schoolName);
  writeNotNull('degree', instance.degree);
  writeNotNull('year', instance.year);
  return val;
}
