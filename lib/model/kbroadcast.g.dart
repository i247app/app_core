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
  ..broadcastID = json['broadcastID'] as String?
  ..byPUID = json['byPUID'] as String?
  ..title = json['title'] as String?
  ..message = json['message'] as String?
  ..promoCode = json['promoCode'] as String?
  ..reserveDate = zzz_str2Date(json['reserveDate'] as String?)
  ..broadcastDate = json['broadcastDate'] as String?
  ..broadcastMax = json['broadcastMax'] as String?
  ..broadcastCount = json['broadcastCount'] as String?
  ..isPaid = zzz_str2Bool(json['isPaid'] as String?)
  ..toAll = zzz_str2Bool(json['toAll'] as String?)
  ..recipients =
      (json['recipients'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..recipientType = json['recipientType'] as String?
  ..addresses = (json['addresses'] as List<dynamic>?)
      ?.map((e) => KAddress.fromJson(e as Map<String, dynamic>))
      .toList()
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..broadcastStatus = json['broadcastStatus'] as String?;

Map<String, dynamic> _$KBroadcastToJson(KBroadcast instance) =>
    <String, dynamic>{
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
      if (instance.broadcastID case final value?) 'broadcastID': value,
      if (instance.byPUID case final value?) 'byPUID': value,
      if (instance.title case final value?) 'title': value,
      if (instance.message case final value?) 'message': value,
      if (instance.promoCode case final value?) 'promoCode': value,
      if (zzz_date2Str(instance.reserveDate) case final value?)
        'reserveDate': value,
      if (instance.broadcastDate case final value?) 'broadcastDate': value,
      if (instance.broadcastMax case final value?) 'broadcastMax': value,
      if (instance.broadcastCount case final value?) 'broadcastCount': value,
      if (zzz_bool2Str(instance.isPaid) case final value?) 'isPaid': value,
      if (zzz_bool2Str(instance.toAll) case final value?) 'toAll': value,
      if (instance.recipients case final value?) 'recipients': value,
      if (instance.recipientType case final value?) 'recipientType': value,
      if (instance.addresses?.map((e) => e.toJson()).toList() case final value?)
        'addresses': value,
      if (instance.latLng?.toJson() case final value?) 'latLng': value,
      if (instance.broadcastStatus case final value?) 'broadcastStatus': value,
    };
