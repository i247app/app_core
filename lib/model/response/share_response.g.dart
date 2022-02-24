// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareResponse _$ShareResponseFromJson(Map<String, dynamic> json) =>
    ShareResponse()
      ..shares = (json['shares'] as List<dynamic>?)
          ?.map((e) => Share.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ShareResponseToJson(ShareResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('shares', instance.shares?.map((e) => e.toJson()).toList());
  return val;
}
