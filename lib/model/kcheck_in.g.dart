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
  ..puid = json['puid'] as String?
  ..placeID = json['placeID'] as String?
  ..addressLine = json['addressLine'] as String?
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..minutePerSession = json['minutePerSession'] as int?
  ..checkInDate = zzz_str2Date(json['checkInDate'] as String?)
  ..checkInStatus = json['checkInStatus'] as String?
  ..address = json['address'] == null
      ? null
      : KGigAddress.fromJson(json['address'] as Map<String, dynamic>);

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
  writeNotNull('kaction', instance.kaction);
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
  writeNotNull('id', instance.id);
  writeNotNull('puid', instance.puid);
  writeNotNull('placeID', instance.placeID);
  writeNotNull('addressLine', instance.addressLine);
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('minutePerSession', instance.minutePerSession);
  writeNotNull('checkInDate', zzz_date2Str(instance.checkInDate));
  writeNotNull('checkInStatus', instance.checkInStatus);
  writeNotNull('address', instance.address?.toJson());
  return val;
}
