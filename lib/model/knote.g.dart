// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNote _$KNoteFromJson(Map<String, dynamic> json) => KNote()
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
  ..id = json['id'] as String?
  ..noteID = json['noteID'] as String?
  ..puid = json['puid'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..messageDate = zzz_str2Date(json['messageDate'] as String?)
  ..messageType = json['messageType'] as String?
  ..message = json['message'] as String?
  ..noteStatus = json['noteStatus'] as String?
  ..imgData = json['imageData'] as String?
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$KNoteToJson(KNote instance) => <String, dynamic>{
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
      if (instance.id case final value?) 'id': value,
      if (instance.noteID case final value?) 'noteID': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.refID case final value?) 'refID': value,
      if (zzz_date2Str(instance.messageDate) case final value?)
        'messageDate': value,
      if (instance.messageType case final value?) 'messageType': value,
      if (instance.message case final value?) 'message': value,
      if (instance.noteStatus case final value?) 'noteStatus': value,
      if (instance.imgData case final value?) 'imageData': value,
      if (instance.user?.toJson() case final value?) 'user': value,
    };
