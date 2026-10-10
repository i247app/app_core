// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_lop_schedules_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetLopSchedulesResponse _$GetLopSchedulesResponseFromJson(
        Map<String, dynamic> json) =>
    GetLopSchedulesResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..schedules = (json['lopSchedules'] as List<dynamic>?)
          ?.map((e) => LopSchedule.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GetLopSchedulesResponseToJson(
    GetLopSchedulesResponse instance) {
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
      'lopSchedules', instance.schedules?.map((e) => e.toJson()).toList());
  return val;
}
