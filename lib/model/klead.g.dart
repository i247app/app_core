// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klead.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KLead _$KLeadFromJson(Map<String, dynamic> json) => KLead()
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
  ..id = json['leadID'] as String?
  ..assignID = json['assignID'] as String?
  ..assignUser = json['assignUser'] == null
      ? null
      : KUser.fromJson(json['assignUser'] as Map<String, dynamic>)
  ..puid = json['puid'] as String?
  ..businessName = json['businessName'] as String?
  ..name = json['name'] as String?
  ..fone = json['fone'] as String?
  ..foneCode = json['foneCode'] as String?
  ..email = json['email'] as String?
  ..addressLine = json['addressLine'] as String?
  ..leadNote = json['leadNote'] as String?
  ..leadStatus = json['leadStatus'] as String?
  ..leadDate = json['leadDate'] as String?
  ..userType = json['userType'] as String?
  ..mediumType = json['mediumType'] as String?
  ..grade = json['grade'] as String?
  ..latLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..interests =
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..byID = json['byID'] as String?
  ..byDate = zzz_str2Date(json['byDate'] as String?)
  ..addresses = (json['addresses'] as List<dynamic>?)
      ?.map((e) => KAddress.fromJson(e as Map<String, dynamic>))
      .toList()
  ..chotDate = zzz_str2Date(json['chotDate'] as String?)
  ..chotStatus = json['chotStatus'] as String?
  ..leadPriority = zzz_atoi(json['leadPriority'] as String?)
  ..leadType = json['leadType'] as String?
  ..buoi = zzz_atoi(json['buoi'] as String?)
  ..phut = zzz_atoi(json['phut'] as String?)
  ..goi = json['goi'] as String?
  ..startDate = zzz_str2Date(json['startDate'] as String?);

Map<String, dynamic> _$KLeadToJson(KLead instance) => <String, dynamic>{
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
      if (instance.id case final value?) 'leadID': value,
      if (instance.assignID case final value?) 'assignID': value,
      if (instance.assignUser?.toJson() case final value?) 'assignUser': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.businessName case final value?) 'businessName': value,
      if (instance.name case final value?) 'name': value,
      if (instance.fone case final value?) 'fone': value,
      if (instance.foneCode case final value?) 'foneCode': value,
      if (instance.email case final value?) 'email': value,
      if (instance.addressLine case final value?) 'addressLine': value,
      if (instance.leadNote case final value?) 'leadNote': value,
      if (instance.leadStatus case final value?) 'leadStatus': value,
      if (instance.leadDate case final value?) 'leadDate': value,
      if (instance.userType case final value?) 'userType': value,
      if (instance.mediumType case final value?) 'mediumType': value,
      if (instance.grade case final value?) 'grade': value,
      if (instance.latLng?.toJson() case final value?) 'latLng': value,
      if (instance.interests case final value?) 'interests': value,
      if (instance.byID case final value?) 'byID': value,
      if (zzz_date2Str(instance.byDate) case final value?) 'byDate': value,
      if (instance.addresses?.map((e) => e.toJson()).toList() case final value?)
        'addresses': value,
      if (zzz_date2Str(instance.chotDate) case final value?) 'chotDate': value,
      if (instance.chotStatus case final value?) 'chotStatus': value,
      if (zzz_itoa(instance.leadPriority) case final value?)
        'leadPriority': value,
      if (instance.leadType case final value?) 'leadType': value,
      if (zzz_itoa(instance.buoi) case final value?) 'buoi': value,
      if (zzz_itoa(instance.phut) case final value?) 'phut': value,
      if (instance.goi case final value?) 'goi': value,
      if (zzz_date2Str(instance.startDate) case final value?)
        'startDate': value,
    };
