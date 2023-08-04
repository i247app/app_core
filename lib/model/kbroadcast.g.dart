// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbroadcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBroadcast _$KBroadcastFromJson(Map<String, dynamic> json) => KBroadcast()
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
  ..broadcast = json['broadcast'] as String?
  ..broadcastID = json['broadcastID'] as String?
  ..byPUID = json['byPuid'] as String?
  ..title = json['title'] as String?
  ..message = json['message'] as String?
  ..promoCode = json['promoCode'] as String?
  ..reserveDate = zzz_str2Date(json['reserveDate'] as String?)
  ..broadcastDate = json['broadcastDate'] as String?
  ..count = json['count'] as String?
  ..isPaid = zzz_str2Bool(json['isPaid'] as String?)
  ..toAll = zzz_str2Bool(json['toAll'] as String?)
  ..broadcastStatus = json['broadcastStatus'] as String?
  ..recipients =
      (json['recipients'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..recipientType = json['recipientType'] as String?;

Map<String, dynamic> _$KBroadcastToJson(KBroadcast instance) {
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
  writeNotNull('kvalue', instance.kvalue);
  writeNotNull('ktags', instance.ktags);
  writeNotNull('kfts', instance.kfts);
  writeNotNull('kranking', instance.kranking);
  writeNotNull('krange', instance.krange);
  writeNotNull('statuses', instance.statuses);
  writeNotNull('korderBy', instance.korderBy);
  writeNotNull('klimit', instance.klimit);
  writeNotNull('koffset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('kname', instance.kname);
  writeNotNull('broadcast', instance.broadcast);
  writeNotNull('broadcastID', instance.broadcastID);
  writeNotNull('byPuid', instance.byPUID);
  writeNotNull('title', instance.title);
  writeNotNull('message', instance.message);
  writeNotNull('promoCode', instance.promoCode);
  writeNotNull('reserveDate', zzz_date2Str(instance.reserveDate));
  writeNotNull('broadcastDate', instance.broadcastDate);
  writeNotNull('count', instance.count);
  writeNotNull('isPaid', zzz_bool2Str(instance.isPaid));
  writeNotNull('toAll', zzz_bool2Str(instance.toAll));
  writeNotNull('broadcastStatus', instance.broadcastStatus);
  writeNotNull('recipients', instance.recipients);
  writeNotNull('recipientType', instance.recipientType);
  return val;
}
