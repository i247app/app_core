// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kstore_hour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KStoreHour _$KStoreHourFromJson(Map<String, dynamic> json) => KStoreHour()
  ..buid = json['buid'] as String?
  ..storeID = json['storeID'] as String?
  ..open = json['openTime'] as String?
  ..close = json['closeTime'] as String?
  ..dayIndex = json['day'] as String?;

Map<String, dynamic> _$KStoreHourToJson(KStoreHour instance) =>
    <String, dynamic>{
      if (instance.buid case final value?) 'buid': value,
      if (instance.storeID case final value?) 'storeID': value,
      if (instance.open case final value?) 'openTime': value,
      if (instance.close case final value?) 'closeTime': value,
      if (instance.dayIndex case final value?) 'day': value,
    };
