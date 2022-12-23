import 'package:app_core/model/klead.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_sales_leads_response.g.dart';

@JsonSerializable()
class KGetSalesLeadsResponse extends BaseResponse {
  @JsonKey(name: "leads")
  List<KLead>? leads;

  // JSON
  KGetSalesLeadsResponse();

  factory KGetSalesLeadsResponse.fromJson(Map<String, dynamic> json) =>
      _$KGetSalesLeadsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KGetSalesLeadsResponseToJson(this);
}
