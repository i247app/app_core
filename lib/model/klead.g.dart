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
  ..action = json['action'] as String?
  ..kattribute = json['kattribute'] as String?
  ..korderBy = json['orderBy'] as String?
  ..klimit = json['limit'] as String?
  ..koffset = json['offset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
  ..id = json['leadID'] as String?
  ..ownerID = json['ownerID'] as String?
  ..contactID = json['contactID'] as String?
  ..businessName = json['businessName'] as String?
  ..contactName = json['contactName'] as String?
  ..phoneNumber = json['fone'] as String?
  ..phoneNumberCode = json['foneCode'] as String?
  ..email = json['email'] as String?
  ..address = json['addressLine'] as String?
  ..leadNote = json['leadNote'] as String?
  ..leadStatus = json['leadStatus'] as String?
  ..leadDate = json['leadDate'] as String?
  ..kuid = json['kuid'] as String?
  ..userType = json['userType'] as String?
  ..gigMedium = json['mediumType'] as String?
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
      .toList();

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
  writeNotNull('action', instance.action);
  writeNotNull('kattribute', instance.kattribute);
  writeNotNull('orderBy', instance.korderBy);
  writeNotNull('limit', instance.klimit);
  writeNotNull('offset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('leadID', instance.id);
  writeNotNull('ownerID', instance.ownerID);
  writeNotNull('contactID', instance.contactID);
  writeNotNull('businessName', instance.businessName);
  writeNotNull('contactName', instance.contactName);
  writeNotNull('fone', instance.phoneNumber);
  writeNotNull('foneCode', instance.phoneNumberCode);
  writeNotNull('email', instance.email);
  writeNotNull('addressLine', instance.address);
  writeNotNull('leadNote', instance.leadNote);
  writeNotNull('leadStatus', instance.leadStatus);
  writeNotNull('leadDate', instance.leadDate);
  writeNotNull('kuid', instance.kuid);
  writeNotNull('userType', instance.userType);
  writeNotNull('mediumType', instance.gigMedium);
  writeNotNull('grade', instance.grade);
  writeNotNull('latLng', instance.latLng?.toJson());
  writeNotNull('interests', instance.interests);
  writeNotNull('byID', instance.byID);
  writeNotNull('byDate', zzz_date2Str(instance.byDate));
  writeNotNull(
      'addresses', instance.addresses?.map((e) => e.toJson()).toList());
  return val;
}
