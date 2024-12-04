// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course()
  ..kdomain = json['domain'] as String?
  ..kreportFlag = json['reportFlag'] as String?
  ..knote = json['note'] as String?
  ..kstatusCode = json['statusCode'] as String?
  ..kcreateID = json['createID'] as String?
  ..kcreateDate = zzz_str2Date(json['createDate'] as String?)
  ..kmodifyID = json['modifyID'] as String?
  ..kmodifyDate = zzz_str2Date(json['modifyDate'] as String?)
  ..kisValid = json['isValid'] as String?
  ..kaction = json['kaction'] as String?
  ..kattribute = json['kattribute'] as String?
  ..kvalue = json['kvalue'] as String?
  ..ktags = json['ktags'] as String?
  ..kfts = json['kfts'] as String?
  ..kranking = json['kranking'] as String?
  ..krange = json['krange'] as String?
  ..statuses =
      (json['statuses'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..korderBy = json['korderBy'] as String?
  ..klimit = json['klimit'] as String?
  ..koffset = json['koffset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
  ..kname = json['kname'] as String?
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
      .toList();

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      if (instance.kdomain case final value?) 'domain': value,
      if (instance.kreportFlag case final value?) 'reportFlag': value,
      if (instance.knote case final value?) 'note': value,
      if (instance.kstatusCode case final value?) 'statusCode': value,
      if (instance.kcreateID case final value?) 'createID': value,
      if (zzz_date2Str(instance.kcreateDate) case final value?)
        'createDate': value,
      if (instance.kmodifyID case final value?) 'modifyID': value,
      if (zzz_date2Str(instance.kmodifyDate) case final value?)
        'modifyDate': value,
      if (instance.kisValid case final value?) 'isValid': value,
      if (instance.kaction case final value?) 'kaction': value,
      if (instance.kattribute case final value?) 'kattribute': value,
      if (instance.kvalue case final value?) 'kvalue': value,
      if (instance.ktags case final value?) 'ktags': value,
      if (instance.kfts case final value?) 'kfts': value,
      if (instance.kranking case final value?) 'kranking': value,
      if (instance.krange case final value?) 'krange': value,
      if (instance.statuses case final value?) 'statuses': value,
      if (instance.korderBy case final value?) 'korderBy': value,
      if (instance.klimit case final value?) 'klimit': value,
      if (instance.koffset case final value?) 'koffset': value,
      if (instance.kstatus case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.kcount case final value?) 'kcount': value,
      if (instance.kname case final value?) 'kname': value,
      if (instance.courseID case final value?) 'courseID': value,
      if (instance.courseType case final value?) 'courseType': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.providerID case final value?) 'providerID': value,
      if (instance.providerName case final value?) 'providerName': value,
      if (instance.courseStatus case final value?) 'courseStatus': value,
      if (instance.level case final value?) 'level': value,
      if (instance.grade case final value?) 'grade': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.textbooks?.map((e) => e.toJson()).toList() case final value?)
        'lopTextbooks': value,
    };
