// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgig_nav.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGigNav _$KGigNavFromJson(Map<String, dynamic> json) => KGigNav()
  ..homework = zzz_gigNavTryAtoi(json['homework'])
  ..headstart = zzz_gigNavTryAtoi(json['headstart'])
  ..buddy = zzz_gigNavTryAtoi(json['buddy'])
  ..teacher = zzz_gigNavTryAtoi(json['teacher'])
  ..expert = zzz_gigNavTryAtoi(json['expert'])
  ..online = zzz_gigNavTryAtoi(json['online'])
  ..inPerson = zzz_gigNavTryAtoi(json['inPerson'])
  ..tutoring = zzz_gigNavTryAtoi(json['tutoring'])
  ..english = zzz_gigNavTryAtoi(json['english'])
  ..viet = zzz_gigNavTryAtoi(json['viet']);

Map<String, dynamic> _$KGigNavToJson(KGigNav instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('homework', zzz_itoa(instance.homework));
  writeNotNull('headstart', zzz_itoa(instance.headstart));
  writeNotNull('buddy', zzz_itoa(instance.buddy));
  writeNotNull('teacher', zzz_itoa(instance.teacher));
  writeNotNull('expert', zzz_itoa(instance.expert));
  writeNotNull('online', zzz_itoa(instance.online));
  writeNotNull('inPerson', zzz_itoa(instance.inPerson));
  writeNotNull('tutoring', zzz_itoa(instance.tutoring));
  writeNotNull('english', zzz_itoa(instance.english));
  writeNotNull('viet', zzz_itoa(instance.viet));
  return val;
}
