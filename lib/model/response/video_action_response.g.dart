// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoActionResponse _$VideoActionResponseFromJson(Map<String, dynamic> json) =>
    VideoActionResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..foos = (json['foos'] as List<dynamic>?)
          ?.map((e) => KFoo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$VideoActionResponseToJson(VideoActionResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('foos', instance.foos?.map((e) => e.toJson()).toList());
  return val;
}
