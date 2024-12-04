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
        ListTextbooksResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.textbooks?.map((e) => e.toJson()).toList() case final value?)
        'textbooks': value,
    };
