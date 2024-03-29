// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgig_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGigUser _$KGigUserFromJson(Map<String, dynamic> json) => KGigUser()
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
  ..isWorking = zzz_str2Bool(json['isWorking'] as String?)
  ..gigCount = json['gigCount'] as String?
  ..puid = json['puid'] as String?
  ..kunm = json['kunm'] as String?
  ..phone = json['fone'] as String?
  ..phoneCode = json['foneCode'] as String?
  ..email = json['email'] as String?
  ..firstName = json['firstName'] as String?
  ..middleName = json['middleName'] as String?
  ..lastName = json['lastName'] as String?
  ..dob = zzz_str2Date(json['dob'] as String?)
  ..ppuid = json['ppuid'] as String?
  ..parentName = json['parentName'] as String?
  ..parentEmail = json['parentEmail'] as String?
  ..parentPhone = json['parentPhone'] as String?
  ..addressLine = json['addressLine'] as String?
  ..addressLine1 = json['addressLine1'] as String?
  ..addressLine2 = json['addressLine2'] as String?
  ..city = json['city'] as String?
  ..stateCode = json['stateCode'] as String?
  ..zipCode = json['zipCode'] as String?
  ..ward = json['ward'] as String?
  ..district = json['district'] as String?
  ..countryCode = json['countryCode'] as String?
  ..displayImg = json['displayImg'] as String?
  ..avatarURL = json['avatar'] as String?
  ..videoURL = json['vurl'] as String?
  ..avatarImageData = json['avatarData'] as String?
  ..heroAvatarURL = json['heroAvatar'] as String?
  ..gradeLevel = json['gradeLevel'] as String?
  ..schoolName = json['schoolName'] as String?
  ..businessName = json['businessName'] as String?
  ..userRating = json['userRating'] as String?
  ..userStatus = json['userStatus'] as String?
  ..userRatingCount = json['userRatingCount'] as String?
  ..bankID = json['bankID'] as String?
  ..bankName = json['bankName'] as String?
  ..bankAccName = json['bankAccName'] as String?
  ..bankAccNumber = json['bankAccNumber'] as String?
  ..educations = (json['educations'] as List<dynamic>?)
      ?.map((e) => KEducation.fromJson(e as Map<String, dynamic>))
      .toList()
  ..addresses = (json['addresses'] as List<dynamic>?)
      ?.map((e) => KAddress.fromJson(e as Map<String, dynamic>))
      .toList()
  ..notes = (json['notes'] as List<dynamic>?)
      ?.map((e) => KNote.fromJson(e as Map<String, dynamic>))
      .toList()
  ..officialIDNumber = json['officialIDNumber'] as String?
  ..officialIDURL = json['officialIDURL'] as String?
  ..officialIDData = json['officialIDData'] as String?
  ..studentIDNumber = json['studentIDNumber'] as String?
  ..studentIDURL = json['studentIDURL'] as String?
  ..studentIDData = json['studentIDData'] as String?
  ..joinDate = zzz_str2Date(json['joinDate'] as String?)
  ..currentLatLng = json['latLng'] == null
      ? null
      : KLatLng.fromJson(json['latLng'] as Map<String, dynamic>)
  ..linkStatus = json['linkStatus'] as String?
  ..distance = zzz_atod(json['distance'] as String?)
  ..cvText = json['cvText'] as String?
  ..billDate = zzz_str2Date(json['billDate'] as String?)
  ..billGigs = json['billGigs'] as String?
  ..billDuration = zzz_str2Dur(json['billDuration'] as String?)
  ..billAmount = json['billAmount'] as String?
  ..billNote = json['billNote'] as String?
  ..billPayDate = zzz_str2Date(json['billPayDate'] as String?)
  ..billPayAmount = json['billPayAmount'] as String?
  ..billPayNote = json['billPayNote'] as String?
  ..tierRate = json['tierRate'] as String?;

Map<String, dynamic> _$KGigUserToJson(KGigUser instance) {
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
  writeNotNull('isWorking', zzz_bool2Str(instance.isWorking));
  writeNotNull('gigCount', instance.gigCount);
  writeNotNull('puid', instance.puid);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('fone', instance.phone);
  writeNotNull('foneCode', instance.phoneCode);
  writeNotNull('email', instance.email);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('middleName', instance.middleName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('dob', zzz_date2Str(instance.dob));
  writeNotNull('ppuid', instance.ppuid);
  writeNotNull('parentName', instance.parentName);
  writeNotNull('parentEmail', instance.parentEmail);
  writeNotNull('parentPhone', instance.parentPhone);
  writeNotNull('addressLine', instance.addressLine);
  writeNotNull('addressLine1', instance.addressLine1);
  writeNotNull('addressLine2', instance.addressLine2);
  writeNotNull('city', instance.city);
  writeNotNull('stateCode', instance.stateCode);
  writeNotNull('zipCode', instance.zipCode);
  writeNotNull('ward', instance.ward);
  writeNotNull('district', instance.district);
  writeNotNull('countryCode', instance.countryCode);
  writeNotNull('displayImg', instance.displayImg);
  writeNotNull('avatar', instance.avatarURL);
  writeNotNull('vurl', instance.videoURL);
  writeNotNull('avatarData', instance.avatarImageData);
  writeNotNull('heroAvatar', instance.heroAvatarURL);
  writeNotNull('gradeLevel', instance.gradeLevel);
  writeNotNull('schoolName', instance.schoolName);
  writeNotNull('businessName', instance.businessName);
  writeNotNull('userRating', instance.userRating);
  writeNotNull('userStatus', instance.userStatus);
  writeNotNull('userRatingCount', instance.userRatingCount);
  writeNotNull('bankID', instance.bankID);
  writeNotNull('bankName', instance.bankName);
  writeNotNull('bankAccName', instance.bankAccName);
  writeNotNull('bankAccNumber', instance.bankAccNumber);
  writeNotNull(
      'educations', instance.educations?.map((e) => e.toJson()).toList());
  writeNotNull(
      'addresses', instance.addresses?.map((e) => e.toJson()).toList());
  writeNotNull('notes', instance.notes?.map((e) => e.toJson()).toList());
  writeNotNull('officialIDNumber', instance.officialIDNumber);
  writeNotNull('officialIDURL', instance.officialIDURL);
  writeNotNull('officialIDData', instance.officialIDData);
  writeNotNull('studentIDNumber', instance.studentIDNumber);
  writeNotNull('studentIDURL', instance.studentIDURL);
  writeNotNull('studentIDData', instance.studentIDData);
  writeNotNull('joinDate', zzz_date2Str(instance.joinDate));
  writeNotNull('latLng', instance.currentLatLng?.toJson());
  writeNotNull('linkStatus', instance.linkStatus);
  writeNotNull('distance', zzz_dtoa(instance.distance));
  writeNotNull('cvText', instance.cvText);
  writeNotNull('billDate', zzz_date2Str(instance.billDate));
  writeNotNull('billGigs', instance.billGigs);
  writeNotNull('billDuration', zzz_dur2Str(instance.billDuration));
  writeNotNull('billAmount', instance.billAmount);
  writeNotNull('billNote', instance.billNote);
  writeNotNull('billPayDate', zzz_date2Str(instance.billPayDate));
  writeNotNull('billPayAmount', instance.billPayAmount);
  writeNotNull('billPayNote', instance.billPayNote);
  writeNotNull('tierRate', instance.tierRate);
  return val;
}
