// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_share_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveShareResponse _$LiveShareResponseFromJson(Map<String, dynamic> json) =>
    LiveShareResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..ssID = json['ssID'] as String?
      ..shares = (json['shares'] as List<dynamic>?)
          ?.map((e) => LiveShare.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$LiveShareResponseToJson(LiveShareResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('ssID', instance.ssID);
  writeNotNull('shares', instance.shares?.map((e) => e.toJson()).toList());
  return val;
}
