// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_summary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostSummaryItem _$CostSummaryItemFromJson(Map<String, dynamic> json) =>
    CostSummaryItem()
      ..label = json['label'] as String?
      ..value = json['value'] as String?;

Map<String, dynamic> _$CostSummaryItemToJson(CostSummaryItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('label', instance.label);
  writeNotNull('value', instance.value);
  return val;
}
