// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbroadcast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KBroadcastResponse _$KBroadcastResponseFromJson(Map<String, dynamic> json) =>
    KBroadcastResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..broadcasts = (json['kbroadcasts'] as List<dynamic>?)
          ?.map((e) => KBroadcast.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KBroadcastResponseToJson(KBroadcastResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull(
      'kbroadcasts', instance.broadcasts?.map((e) => e.toJson()).toList());
  return val;
}
