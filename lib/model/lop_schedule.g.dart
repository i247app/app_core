// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lop_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LopSchedule _$LopScheduleFromJson(Map<String, dynamic> json) => LopSchedule()
  ..kdomain = json['domain'] as String?
  ..kreportFlag = json['reportFlag'] as String?
  ..knote = json['note'] as String?
  ..kstatusCode = json['statusCode'] as String?
  ..kcreateID = json['createID'] as String?
  ..kcreateDate = zzz_str2Date(json['createDate'] as String?)
  ..kmodifyID = json['modifyID'] as String?
  ..kmodifyDate = zzz_str2Date(json['modifyDate'] as String?)
  ..kisValid = json['isValid'] as String?
  ..action = json['action'] as String?
  ..kattribute = json['kattribute'] as String?
  ..korderBy = json['orderBy'] as String?
  ..klimit = json['limit'] as String?
  ..koffset = json['offset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
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
      .toList()
  ..lopScheduleID = json['scheduleID'] as String?
  ..startTime = zzz_str2Date(json['startTime'] as String?)
  ..endTime = zzz_str2Date(json['endTime'] as String?)
  ..lopScheduleStatus = json['scheduleStatus'] as String?
  ..externalLink = json['externalLink'] as String?;

Map<String, dynamic> _$LopScheduleToJson(LopSchedule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('domain', instance.kdomain);
  writeNotNull('reportFlag', instance.kreportFlag);
  writeNotNull('note', instance.knote);
  writeNotNull('statusCode', instance.kstatusCode);
  writeNotNull('createID', instance.kcreateID);
  writeNotNull('createDate', zzz_date2Str(instance.kcreateDate));
  writeNotNull('modifyID', instance.kmodifyID);
  writeNotNull('modifyDate', zzz_date2Str(instance.kmodifyDate));
  writeNotNull('isValid', instance.kisValid);
  writeNotNull('action', instance.action);
  writeNotNull('kattribute', instance.kattribute);
  writeNotNull('orderBy', instance.korderBy);
  writeNotNull('limit', instance.klimit);
  writeNotNull('offset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
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
  writeNotNull('scheduleID', instance.lopScheduleID);
  writeNotNull('startTime', zzz_date2Str(instance.startTime));
  writeNotNull('endTime', zzz_date2Str(instance.endTime));
  writeNotNull('scheduleStatus', instance.lopScheduleStatus);
  writeNotNull('externalLink', instance.externalLink);
  return val;
}
