// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_textbooks_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListTextbooksResponse _$ListTextbooksResponseFromJson(
        Map<String, dynamic> json) =>
    ListTextbooksResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..textbooks = (json['textbooks'] as List<dynamic>?)
          ?.map((e) => Textbook.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ListTextbooksResponseToJson(
    ListTextbooksResponse instance) {
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
      'textbooks', instance.textbooks?.map((e) => e.toJson()).toList());
  return val;
}
