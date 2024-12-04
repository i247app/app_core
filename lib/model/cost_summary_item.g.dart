// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_summary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostSummaryItem _$CostSummaryItemFromJson(Map<String, dynamic> json) =>
    CostSummaryItem()
      ..label = json['label'] as String?
      ..value = json['value'] as String?;

Map<String, dynamic> _$CostSummaryItemToJson(CostSummaryItem instance) =>
    <String, dynamic>{
      if (instance.label case final value?) 'label': value,
      if (instance.value case final value?) 'value': value,
    };
