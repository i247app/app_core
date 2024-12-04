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
        GetLopSchedulesResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.schedules?.map((e) => e.toJson()).toList() case final value?)
        'lopSchedules': value,
    };
