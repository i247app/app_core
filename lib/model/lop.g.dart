// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lop _$LopFromJson(Map<String, dynamic> json) => Lop()
  ..courseID = json['courseID'] as String?
  ..courseType = json['courseType'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..providerID = json['providerID'] as String?
  ..providerName = json['providerName'] as String?
  ..courseStatus = json['courseStatus'] as String?
  ..level = json['level'] as String?
  ..grade = json['grade'] as String?
  ..tags = json['tags'] as String?
  ..textbooks = (json['lopTextbooks'] as List<dynamic>?)
      ?.map((e) => Textbook.fromJson(e as Map<String, dynamic>))
      .toList()
  ..lopID = json['lopID'] as String?
  ..capacity = json['capacity'] as String?
  ..count = json['count'] as String?
  ..lopStatus = json['lopStatus'] as String?
  ..startDate = zzz_str2Date(json['startDate'] as String?)
  ..endDate = zzz_str2Date(json['endDate'] as String?)
  ..students = (json['lopStudents'] as List<dynamic>?)
      ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
      .toList()
  ..instructors = (json['lopInstructors'] as List<dynamic>?)
      ?.map((e) => Tutor.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$LopToJson(Lop instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('courseID', instance.courseID);
  writeNotNull('courseType', instance.courseType);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('providerID', instance.providerID);
  writeNotNull('providerName', instance.providerName);
  writeNotNull('courseStatus', instance.courseStatus);
  writeNotNull('level', instance.level);
  writeNotNull('grade', instance.grade);
  writeNotNull('tags', instance.tags);
  writeNotNull(
      'lopTextbooks', instance.textbooks?.map((e) => e.toJson()).toList());
  writeNotNull('lopID', instance.lopID);
  writeNotNull('capacity', instance.capacity);
  writeNotNull('count', instance.count);
  writeNotNull('lopStatus', instance.lopStatus);
  writeNotNull('startDate', zzz_date2Str(instance.startDate));
  writeNotNull('endDate', zzz_date2Str(instance.endDate));
  writeNotNull(
      'lopStudents', instance.students?.map((e) => e.toJson()).toList());
  writeNotNull(
      'lopInstructors', instance.instructors?.map((e) => e.toJson()).toList());
  return val;
}
