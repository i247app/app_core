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

Map<String, dynamic> _$KStoreHourToJson(KStoreHour instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('buid', instance.buid);
  writeNotNull('storeID', instance.storeID);
  writeNotNull('openTime', instance.open);
  writeNotNull('closeTime', instance.close);
  writeNotNull('day', instance.dayIndex);
  return val;
}
