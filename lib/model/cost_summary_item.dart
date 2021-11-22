import 'package:json_annotation/json_annotation.dart';

part 'cost_summary_item.g.dart';

@JsonSerializable()
class CostSummaryItem {
  static const String LABEL = "label";
  static const String VALUE = "value";

  @JsonKey(name: LABEL)
  String? label;

  @JsonKey(name: VALUE)
  String? value;

  // JSON
  CostSummaryItem();

  factory CostSummaryItem.fromJson(Map<String, dynamic> json) =>
      _$CostSummaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$CostSummaryItemToJson(this);
}
