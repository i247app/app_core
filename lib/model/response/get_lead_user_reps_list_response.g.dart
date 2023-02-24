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
    KGetLeadUserRepsListResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('reps', instance.reps?.map((e) => e.toJson()).toList());
  return val;
}
