// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutor _$TutorFromJson(Map<String, dynamic> json) => Tutor()
  ..kdomain = json['domain'] as String?
  ..kreportFlag = json['reportFlag'] as String?
  ..knote = json['note'] as String?
  ..kstatusCode = json['statusCode'] as String?
  ..kcreateID = json['createID'] as String?
  ..kcreateDate = zzz_str2Date(json['createDate'] as String?)
  ..kmodifyID = json['modifyID'] as String?
  ..kmodifyDate = zzz_str2Date(json['modifyDate'] as String?)
  ..kisValid = json['isValid'] as String?
  ..kattribute = json['kattribute'] as String?
  ..korderBy = json['orderBy'] as String?
  ..klimit = json['limit'] as String?
  ..koffset = json['offset'] as String?
  ..kstatus = json['kstatus'] as String?
  ..kmessage = json['kmessage'] as String?
  ..kcount = json['kcount'] as String?
  ..isWorking = zzz_str2Bool(json['isWorking'] as String?)
  ..action = json['action'] as String?
  ..gigCount = json['gigCount'] as String?
  ..puid = json['puid'] as String?
  ..kunm = json['kunm'] as String?
  ..phone = json['fone'] as String?
  ..phoneCode = json['foneCode'] as String?
  ..addressLine = json['addressLine'] as String?
  ..email = json['email'] as String?
  ..firstName = json['firstName'] as String?
  ..middleName = json['middleName'] as String?
  ..lastName = json['lastName'] as String?
  ..dob = zzz_str2Date(json['dob'] as String?)
  ..ppuid = json['ppuid'] as String?
  ..parentName = json['parentName'] as String?
  ..parentEmail = json['parentEmail'] as String?
  ..parentPhone = json['parentPhone'] as String?
  ..address1 = json['addressLine1'] as String?
  ..address2 = json['addressLine2'] as String?
  ..city = json['city'] as String?
  ..stateCode = json['stateCode'] as String?
  ..zip = json['zipCode'] as String?
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
  ..review = json['rating'] == null
      ? null
      : Review.fromJson(json['rating'] as Map<String, dynamic>)
  ..tutorID = json['tutorID'] as String?
  ..canInPerson = zzz_str2Bool(json['canInPerson'] as String?)
  ..canHeadstart = zzz_str2Bool(json['canHeadstart'] as String?)
  ..canEnglish = zzz_str2Bool(json['canEnglish'] as String?)
  ..canViet = zzz_str2Bool(json['canViet'] as String?)
  ..isSkill = zzz_str2Bool(json['isSkill'] as String?)
  ..isGenius = zzz_str2Bool(json['isGenius'] as String?)
  ..isKeepWorker = zzz_str2Bool(json['isKeepWorker'] as String?)
  ..isBlockWorker = zzz_str2Bool(json['isBlockWorker'] as String?)
  ..tutorStatus = json['tutorStatus'] as String?
  ..userType = json['userType'] as String?
  ..userTags = (json['userTags'] as List<dynamic>?)
      ?.map((e) => UserTag.fromJson(e as Map<String, dynamic>))
      .toList()
  ..activeDate = zzz_str2Date(json['activeDate'] as String?)
  ..tutorJoinDate = zzz_str2Date(json['tutorJoinDate'] as String?)
  ..mathLevelMin = json['mathLevelMin'] as String?
  ..mathLevelMax = json['mathLevelMax'] as String?
  ..vietLevelMin = json['vietLevelMin'] as String?
  ..vietLevelMax = json['vietLevelMax'] as String?
  ..englishLevelMin = json['englishLevelMin'] as String?
  ..englishLevelMax = json['englishLevelMax'] as String?
  ..canOnline = zzz_str2Bool(json['canOnline'] as String?)
  ..subjects =
      (json['subjects'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$TutorToJson(Tutor instance) {
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
  writeNotNull('kattribute', instance.kattribute);
  writeNotNull('orderBy', instance.korderBy);
  writeNotNull('limit', instance.klimit);
  writeNotNull('offset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('isWorking', zzz_bool2Str(instance.isWorking));
  writeNotNull('action', instance.action);
  writeNotNull('gigCount', instance.gigCount);
  writeNotNull('puid', instance.puid);
  writeNotNull('kunm', instance.kunm);
  writeNotNull('fone', instance.phone);
  writeNotNull('foneCode', instance.phoneCode);
  writeNotNull('addressLine', instance.addressLine);
  writeNotNull('email', instance.email);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('middleName', instance.middleName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('dob', zzz_date2Str(instance.dob));
  writeNotNull('ppuid', instance.ppuid);
  writeNotNull('parentName', instance.parentName);
  writeNotNull('parentEmail', instance.parentEmail);
  writeNotNull('parentPhone', instance.parentPhone);
  writeNotNull('addressLine1', instance.address1);
  writeNotNull('addressLine2', instance.address2);
  writeNotNull('city', instance.city);
  writeNotNull('stateCode', instance.stateCode);
  writeNotNull('zipCode', instance.zip);
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
  writeNotNull('rating', instance.review?.toJson());
  writeNotNull('tutorID', instance.tutorID);
  writeNotNull('canInPerson', zzz_bool2Str(instance.canInPerson));
  writeNotNull('canHeadstart', zzz_bool2Str(instance.canHeadstart));
  writeNotNull('canEnglish', zzz_bool2Str(instance.canEnglish));
  writeNotNull('canViet', zzz_bool2Str(instance.canViet));
  writeNotNull('isSkill', zzz_bool2Str(instance.isSkill));
  writeNotNull('isGenius', zzz_bool2Str(instance.isGenius));
  writeNotNull('isKeepWorker', zzz_bool2Str(instance.isKeepWorker));
  writeNotNull('isBlockWorker', zzz_bool2Str(instance.isBlockWorker));
  writeNotNull('tutorStatus', instance.tutorStatus);
  writeNotNull('userType', instance.userType);
  writeNotNull('userTags', instance.userTags?.map((e) => e.toJson()).toList());
  writeNotNull('activeDate', zzz_date2Str(instance.activeDate));
  writeNotNull('tutorJoinDate', zzz_date2Str(instance.tutorJoinDate));
  writeNotNull('mathLevelMin', instance.mathLevelMin);
  writeNotNull('mathLevelMax', instance.mathLevelMax);
  writeNotNull('vietLevelMin', instance.vietLevelMin);
  writeNotNull('vietLevelMax', instance.vietLevelMax);
  writeNotNull('englishLevelMin', instance.englishLevelMin);
  writeNotNull('englishLevelMax', instance.englishLevelMax);
  writeNotNull('canOnline', zzz_bool2Str(instance.canOnline));
  writeNotNull('subjects', instance.subjects);
  return val;
}
