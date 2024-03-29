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

Map<String, dynamic> _$KLeadToJson(KLead instance) {
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
  writeNotNull('leadID', instance.id);
  writeNotNull('assignID', instance.assignID);
  writeNotNull('assignUser', instance.assignUser?.toJson());
  writeNotNull('puid', instance.puid);
  writeNotNull('businessName', instance.businessName);
  writeNotNull('name', instance.name);
  writeNotNull('fone', instance.fone);
  writeNotNull('foneCode', instance.foneCode);
  writeNotNull('email', instance.email);
  writeNotNull('addressLine', instance.addressLine);
  writeNotNull('leadNote', instance.leadNote);
  writeNotNull('leadStatus', instance.leadStatus);
  writeNotNull('leadDate', instance.leadDate);
  writeNotNull('userType', instance.userType);
  writeNotNull('mediumType', instance.mediumType);
  writeNotNull('grade', instance.grade);
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('interests', instance.interests);
  writeNotNull('byID', instance.byID);
  writeNotNull('byDate', zzz_date2Str(instance.byDate));
  writeNotNull(
      'addresses', instance.addresses?.map((e) => e.toJson()).toList());
  writeNotNull('chotDate', zzz_date2Str(instance.chotDate));
  writeNotNull('chotStatus', instance.chotStatus);
  writeNotNull('leadPriority', zzz_itoa(instance.leadPriority));
  writeNotNull('leadType', instance.leadType);
  writeNotNull('buoi', zzz_itoa(instance.buoi));
  writeNotNull('phut', zzz_itoa(instance.phut));
  writeNotNull('goi', instance.goi);
  writeNotNull('startDate', zzz_date2Str(instance.startDate));
  return val;
}
