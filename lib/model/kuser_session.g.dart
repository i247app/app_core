// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuser_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KUserSession _$KUserSessionFromJson(Map<String, dynamic> json) => KUserSession()
  ..ktoken = json['ktoken'] as String?
  ..puid = json['puid'] as String?
  ..googleMapAPIKey = json['googleMapAPIKey'] as String?
  ..user = json['user'] == null
      ? null
      : KUser.fromJson(json['user'] as Map<String, dynamic>)
  ..hostData = json['hostData'] == null
      ? null
      : KSystemHostData.fromJson(json['hostData'] as Map<String, dynamic>);

Map<String, dynamic> _$KUserSessionToJson(KUserSession instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('puid', instance.puid);
  writeNotNull('googleMapAPIKey', instance.googleMapAPIKey);
  writeNotNull('user', instance.user?.toJson());
  writeNotNull('hostData', instance.hostData?.toJson());
  return val;
}
