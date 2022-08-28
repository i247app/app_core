// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kcv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KCV _$KCVFromJson(Map<String, dynamic> json) => KCV()
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
  ..korderBy = json['orderBy'] as String?
  ..klimit = json['limit'] as String?
  ..koffset = json['offset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
  ..cv = json['cv'] as String?
  ..id = json['id'] as String?
  ..puid = json['puid'] as String?
  ..cvDate = json['cvDate'] as String?
  ..cvText = json['cvText'] as String?
  ..cvStatus = json['cvStatus'] as String?
  ..kunm = json['kunm'] as String?
  ..firstName = json['firstName'] as String?
  ..middleName = json['middleName'] as String?
  ..lastName = json['lastName'] as String?
  ..avatar = json['avatar'] as String?
  ..user = json['user'] as String?;

Map<String, dynamic> _$KCVToJson(KCV instance) {
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
  writeNotNull('orderBy', instance.korderBy);
  writeNotNull('limit', instance.klimit);
  writeNotNull('offset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('cv', instance.cv);
  writeNotNull('id', instance.id);
  writeNotNull('puid', instance.puid);
  writeNotNull('cvDate', instance.cvDate);
  writeNotNull('cvText', instance.cvText);
  writeNotNull('cvStatus', instance.cvStatus);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('middleName', instance.middleName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('user', instance.user);
  return val;
}
