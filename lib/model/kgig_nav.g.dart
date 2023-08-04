// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kgig_nav.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KGigNav _$KGigNavFromJson(Map<String, dynamic> json) => KGigNav()
  ..homework = zzz_gigNavTryAtoi(json['homework'])
  ..headstart = zzz_gigNavTryAtoi(json['headstart'])
  ..monEnglish = zzz_gigNavTryAtoi(json['monEnglish'])
  ..monViet = zzz_gigNavTryAtoi(json['monViet'])
  ..monMath = zzz_gigNavTryAtoi(json['monMath'])
  ..buddy = zzz_gigNavTryAtoi(json['buddy'])
  ..teacher = zzz_gigNavTryAtoi(json['teacher'])
  ..expert = zzz_gigNavTryAtoi(json['expert'])
  ..online = zzz_gigNavTryAtoi(json['online'])
  ..inPerson = zzz_gigNavTryAtoi(json['inPerson'])
  ..tutoring = zzz_gigNavTryAtoi(json['tutoring'])
  ..exam = zzz_gigNavTryAtoi(json['exam'])
  ..english = zzz_gigNavTryAtoi(json['chitEN'])
  ..viet = zzz_gigNavTryAtoi(json['chitVN']);

Map<String, dynamic> _$KGigNavToJson(KGigNav instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('homework', zzz_itoa(instance.homework));
  writeNotNull('headstart', zzz_itoa(instance.headstart));
  writeNotNull('monEnglish', zzz_itoa(instance.monEnglish));
  writeNotNull('monViet', zzz_itoa(instance.monViet));
  writeNotNull('monMath', zzz_itoa(instance.monMath));
  writeNotNull('buddy', zzz_itoa(instance.buddy));
  writeNotNull('teacher', zzz_itoa(instance.teacher));
  writeNotNull('expert', zzz_itoa(instance.expert));
  writeNotNull('online', zzz_itoa(instance.online));
  writeNotNull('inPerson', zzz_itoa(instance.inPerson));
  writeNotNull('tutoring', zzz_itoa(instance.tutoring));
  writeNotNull('exam', zzz_itoa(instance.exam));
  writeNotNull('chitEN', zzz_itoa(instance.english));
  writeNotNull('chitVN', zzz_itoa(instance.viet));
  return val;
}
