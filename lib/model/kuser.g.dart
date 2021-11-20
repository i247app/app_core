// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KUser _$KUserFromJson(Map<String, dynamic> json) {
  return KUser()
    ..kdomain = json['domain'] as String?
    ..kreportFlag = json['reportFlag'] as String?
    ..knote = json['note'] as String?
    ..kstatusCode = json['statusCode'] as String?
    ..kcreateID = json['createID'] as String?
    ..kcreateDate = json['createDate'] as String?
    ..kmodifyID = json['modifyID'] as String?
    ..kmodifyDate = json['modifyDate'] as String?
    ..kisValid = json['isValid'] as String?
    ..kaction = json['action'] as String?
    ..korderBy = json['orderBy'] as String?
    ..klimit = json['limit'] as String?
    ..koffset = json['offset'] as String?
    ..kstatus = json['kstatus'] as String?
    ..kmessage = json['kmessage'] as String?
    ..kcount = json['kcount'] as String?
    ..puid = json['puid'] as String?
    ..kunm = json['kunm'] as String?
    ..phone = json['fone'] as String?
    ..phoneCode = json['foneCode'] as String?
    ..email = json['email'] as String?
    ..firstName = json['firstName'] as String?
    ..middleName = json['middleName'] as String?
    ..lastName = json['lastName'] as String?
    ..dob = zzz_str2Date(json['dob'] as String?)
    ..parentName = json['parentName'] as String?
    ..parentEmail = json['parentEmail'] as String?
    ..parentPhone = json['parentPhone'] as String?
    ..address = json['addressLine1'] as String?
    ..address2 = json['addressLine2'] as String?
    ..city = json['city'] as String?
    ..state = json['stateCode'] as String?
    ..zip = json['zipCode'] as String?
    ..countryCode = json['countryCode'] as String?
    ..displayImg = json['displayImg'] as String?
    ..avatarURL = json['avatar'] as String?
    ..avatarImageData = json['avatarData'] as String?
    ..heroAvatarURL = json['heroAvatar'] as String?
    ..joinDate = zzz_str2Date(json['joinDate'] as String?);
}

Map<String, dynamic> _$KUserToJson(KUser instance) => <String, dynamic>{
      'domain': instance.kdomain,
      'reportFlag': instance.kreportFlag,
      'note': instance.knote,
      'statusCode': instance.kstatusCode,
      'createID': instance.kcreateID,
      'createDate': instance.kcreateDate,
      'modifyID': instance.kmodifyID,
      'modifyDate': instance.kmodifyDate,
      'isValid': instance.kisValid,
      'action': instance.kaction,
      'orderBy': instance.korderBy,
      'limit': instance.klimit,
      'offset': instance.koffset,
      'kstatus': instance.kstatus,
      'kmessage': instance.kmessage,
      'kcount': instance.kcount,
      'puid': instance.puid,
      'kunm': instance.kunm,
      'fone': instance.phone,
      'foneCode': instance.phoneCode,
      'email': instance.email,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'dob': zzz_date2Str(instance.dob),
      'parentName': instance.parentName,
      'parentEmail': instance.parentEmail,
      'parentPhone': instance.parentPhone,
      'addressLine1': instance.address,
      'addressLine2': instance.address2,
      'city': instance.city,
      'stateCode': instance.state,
      'zipCode': instance.zip,
      'countryCode': instance.countryCode,
      'displayImg': instance.displayImg,
      'avatar': instance.avatarURL,
      'avatarData': instance.avatarImageData,
      'heroAvatar': instance.heroAvatarURL,
      'joinDate': zzz_date2Str(instance.joinDate),
    };
