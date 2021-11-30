import 'package:json_annotation/json_annotation.dart';

part 'xfr_proxy.g.dart';

@JsonSerializable()
class XFRProxy {
  static const String PUID = "puid";
  static const String BUID = "buid";
  static const String TOKEN_NAME = "tokenName";
  static const String PROXY_STATUS = "proxyStatus";

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: BUID)
  String? buid;

  @JsonKey(name: TOKEN_NAME)
  String? tokenName;

  @JsonKey(name: PROXY_STATUS)
  String? proxyStatus;

  // Methods

  // JSON
  XFRProxy();

  factory XFRProxy.fromJson(Map<String, dynamic> json) =>
      _$XFRProxyFromJson(json);

  Map<String, dynamic> toJson() => _$XFRProxyToJson(this);
}
