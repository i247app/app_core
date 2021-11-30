import 'package:app_core/app_core.dart';
import 'package:app_core/model/xfr_proxy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_xfr_proxy_response.g.dart';

@JsonSerializable()
class ListXFRProxyResponse extends BaseResponse {
  @JsonKey(name: "xfrProxies")
  List<XFRProxy>? proxies;

  // JSON
  ListXFRProxyResponse();

  factory ListXFRProxyResponse.fromJson(Map<String, dynamic> json) =>
      _$ListXFRProxyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListXFRProxyResponseToJson(this);
}
