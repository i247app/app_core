// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'old_schedules_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OldSchedulesResponse _$OldSchedulesResponseFromJson(
        Map<String, dynamic> json) =>
    OldSchedulesResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..schedules = (json['courses'] as List<dynamic>?)
          ?.map((e) => LopSchedule.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$OldSchedulesResponseToJson(
    OldSchedulesResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('courses', instance.schedules?.map((e) => e.toJson()).toList());
  return val;
}
