// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kcheck_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KCheckIn _$KCheckInFromJson(Map<String, dynamic> json) => KCheckIn()
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
  ..korderBy = json['orderBy'] as String?
  ..klimit = json['limit'] as String?
  ..koffset = json['offset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
  ..id = json['id'] as String?
  ..puid = json['puid'] as String?
  ..placeID = json['placeID'] as String?
  ..addressLine = json['addressLine'] as String?
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..minutePerSession = json['minutePerSession'] as int?
  ..checkInDate = zzz_str2Date(json['checkInDate'] as String?)
  ..checkInStatus = json['checkInStatus'] as String?;

Map<String, dynamic> _$KCheckInToJson(KCheckIn instance) {
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
  writeNotNull('orderBy', instance.korderBy);
  writeNotNull('limit', instance.klimit);
  writeNotNull('offset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('id', instance.id);
  writeNotNull('puid', instance.puid);
  writeNotNull('placeID', instance.placeID);
  writeNotNull('addressLine', instance.addressLine);
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('minutePerSession', instance.minutePerSession);
  writeNotNull('checkInDate', zzz_date2Str(instance.checkInDate));
  writeNotNull('checkInStatus', instance.checkInStatus);
  return val;
}
