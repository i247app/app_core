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
<<<<<<< HEAD
=======
  ..action = json['action'] as String?
>>>>>>> dvl
  ..korderBy = json['orderBy'] as String?
  ..klimit = json['limit'] as String?
  ..koffset = json['offset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
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

Map<String, dynamic> _$KNoteToJson(KNote instance) {
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
<<<<<<< HEAD
=======
  writeNotNull('action', instance.action);
>>>>>>> dvl
  writeNotNull('orderBy', instance.korderBy);
  writeNotNull('limit', instance.klimit);
  writeNotNull('offset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('id', instance.id);
  writeNotNull('noteID', instance.noteID);
  writeNotNull('puid', instance.puid);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('messageDate', zzz_date2Str(instance.messageDate));
  writeNotNull('messageType', instance.messageType);
  writeNotNull('message', instance.message);
  writeNotNull('noteStatus', instance.noteStatus);
  writeNotNull('imageData', instance.imgData);
  writeNotNull('user', instance.user?.toJson());
  return val;
}
