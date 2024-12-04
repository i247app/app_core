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
  ..review = json['rating'] == null
      ? null
      : Review.fromJson(json['rating'] as Map<String, dynamic>)
  ..tutorID = json['tutorID'] as String?
  ..canInPerson = zzz_str2Bool(json['canInPerson'] as String?)
  ..canHeadstart = zzz_str2Bool(json['canHeadstart'] as String?)
  ..canEnglish = zzz_str2Bool(json['canEnglish'] as String?)
  ..canViet = zzz_str2Bool(json['canViet'] as String?)
  ..canSpeakEnglish = zzz_str2Bool(json['canSpeakEnglish'] as String?)
  ..canPreSchool = zzz_str2Bool(json['canPreschool'] as String?)
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

Map<String, dynamic> _$TutorToJson(Tutor instance) => <String, dynamic>{
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
      if (zzz_bool2Str(instance.isWorking) case final value?)
        'isWorking': value,
      if (instance.gigCount case final value?) 'gigCount': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.kunm case final value?) 'kunm': value,
      if (instance.phone case final value?) 'fone': value,
      if (instance.phoneCode case final value?) 'foneCode': value,
      if (instance.email case final value?) 'email': value,
      if (instance.firstName case final value?) 'firstName': value,
      if (instance.middleName case final value?) 'middleName': value,
      if (instance.lastName case final value?) 'lastName': value,
      if (zzz_date2Str(instance.dob) case final value?) 'dob': value,
      if (instance.ppuid case final value?) 'ppuid': value,
      if (instance.parentName case final value?) 'parentName': value,
      if (instance.parentEmail case final value?) 'parentEmail': value,
      if (instance.parentPhone case final value?) 'parentPhone': value,
      if (instance.addressLine case final value?) 'addressLine': value,
      if (instance.addressLine1 case final value?) 'addressLine1': value,
      if (instance.addressLine2 case final value?) 'addressLine2': value,
      if (instance.city case final value?) 'city': value,
      if (instance.stateCode case final value?) 'stateCode': value,
      if (instance.zipCode case final value?) 'zipCode': value,
      if (instance.ward case final value?) 'ward': value,
      if (instance.district case final value?) 'district': value,
      if (instance.countryCode case final value?) 'countryCode': value,
      if (instance.displayImg case final value?) 'displayImg': value,
      if (instance.avatarURL case final value?) 'avatar': value,
      if (instance.videoURL case final value?) 'vurl': value,
      if (instance.avatarImageData case final value?) 'avatarData': value,
      if (instance.heroAvatarURL case final value?) 'heroAvatar': value,
      if (instance.gradeLevel case final value?) 'gradeLevel': value,
      if (instance.schoolName case final value?) 'schoolName': value,
      if (instance.businessName case final value?) 'businessName': value,
      if (instance.userRating case final value?) 'userRating': value,
      if (instance.userStatus case final value?) 'userStatus': value,
      if (instance.userRatingCount case final value?) 'userRatingCount': value,
      if (instance.bankID case final value?) 'bankID': value,
      if (instance.bankName case final value?) 'bankName': value,
      if (instance.bankAccName case final value?) 'bankAccName': value,
      if (instance.bankAccNumber case final value?) 'bankAccNumber': value,
      if (instance.educations?.map((e) => e.toJson()).toList()
          case final value?)
        'educations': value,
      if (instance.addresses?.map((e) => e.toJson()).toList() case final value?)
        'addresses': value,
      if (instance.notes?.map((e) => e.toJson()).toList() case final value?)
        'notes': value,
      if (instance.officialIDNumber case final value?)
        'officialIDNumber': value,
      if (instance.officialIDURL case final value?) 'officialIDURL': value,
      if (instance.officialIDData case final value?) 'officialIDData': value,
      if (instance.studentIDNumber case final value?) 'studentIDNumber': value,
      if (instance.studentIDURL case final value?) 'studentIDURL': value,
      if (instance.studentIDData case final value?) 'studentIDData': value,
      if (zzz_date2Str(instance.joinDate) case final value?) 'joinDate': value,
      if (instance.currentLatLng?.toJson() case final value?) 'latLng': value,
      if (instance.linkStatus case final value?) 'linkStatus': value,
      if (zzz_dtoa(instance.distance) case final value?) 'distance': value,
      if (instance.cvText case final value?) 'cvText': value,
      if (instance.review?.toJson() case final value?) 'rating': value,
      if (instance.tutorID case final value?) 'tutorID': value,
      if (zzz_bool2Str(instance.canInPerson) case final value?)
        'canInPerson': value,
      if (zzz_bool2Str(instance.canHeadstart) case final value?)
        'canHeadstart': value,
      if (zzz_bool2Str(instance.canEnglish) case final value?)
        'canEnglish': value,
      if (zzz_bool2Str(instance.canViet) case final value?) 'canViet': value,
      if (zzz_bool2Str(instance.canSpeakEnglish) case final value?)
        'canSpeakEnglish': value,
      if (zzz_bool2Str(instance.canPreSchool) case final value?)
        'canPreschool': value,
      if (zzz_bool2Str(instance.isSkill) case final value?) 'isSkill': value,
      if (zzz_bool2Str(instance.isGenius) case final value?) 'isGenius': value,
      if (zzz_bool2Str(instance.isKeepWorker) case final value?)
        'isKeepWorker': value,
      if (zzz_bool2Str(instance.isBlockWorker) case final value?)
        'isBlockWorker': value,
      if (instance.tutorStatus case final value?) 'tutorStatus': value,
      if (instance.userType case final value?) 'userType': value,
      if (instance.userTags?.map((e) => e.toJson()).toList() case final value?)
        'userTags': value,
      if (zzz_date2Str(instance.activeDate) case final value?)
        'activeDate': value,
      if (zzz_date2Str(instance.tutorJoinDate) case final value?)
        'tutorJoinDate': value,
      if (instance.mathLevelMin case final value?) 'mathLevelMin': value,
      if (instance.mathLevelMax case final value?) 'mathLevelMax': value,
      if (instance.vietLevelMin case final value?) 'vietLevelMin': value,
      if (instance.vietLevelMax case final value?) 'vietLevelMax': value,
      if (instance.englishLevelMin case final value?) 'englishLevelMin': value,
      if (instance.englishLevelMax case final value?) 'englishLevelMax': value,
      if (zzz_bool2Str(instance.canOnline) case final value?)
        'canOnline': value,
      if (instance.subjects case final value?) 'subjects': value,
    };
