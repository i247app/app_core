// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KUser _$KUserFromJson(Map<String, dynamic> json) {
  return KUser()
    ..puid = json['puid'] as String?
    ..kunm = json['kunm'] as String?
    ..phone = json['fone'] as String?
    ..phoneCode = json['foneCode'] as String?
    ..email = json['email'] as String?
    ..firstName = json['firstName'] as String?
    ..middleName = json['middleName'] as String?
    ..lastName = json['lastName'] as String?
    ..address = json['addressLine1'] as String?
    ..address2 = json['addressLine2'] as String?
    ..city = json['city'] as String?
    ..state = json['stateCode'] as String?
    ..zip = json['zipCode'] as String?
    ..countryCode = json['countryCode'] as String?
    ..displayImg = json['displayImg'] as String?
    ..avatarURL = json['avatar'] as String?
    ..avatarImageData = json['avatarData'] as String?
    ..heroAvatarURL = json['heroAvatar'] as String?;
}

Map<String, dynamic> _$KUserToJson(KUser instance) => <String, dynamic>{
      'puid': instance.puid,
      'kunm': instance.kunm,
      'fone': instance.phone,
      'foneCode': instance.phoneCode,
      'email': instance.email,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
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
    };
