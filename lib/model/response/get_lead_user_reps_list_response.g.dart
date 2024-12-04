// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_lead_user_reps_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGetLeadUserRepsListResponse _$KGetLeadUserRepsListResponseFromJson(
        Map<String, dynamic> json) =>
    KGetLeadUserRepsListResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..reps = (json['reps'] as List<dynamic>?)
          ?.map((e) => KUser.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KGetLeadUserRepsListResponseToJson(
        KGetLeadUserRepsListResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.reps?.map((e) => e.toJson()).toList() case final value?)
        'reps': value,
    };
