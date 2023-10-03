import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';
// import 'package:app_core/model/kbroadcast.dart';
// import 'base_response.dart';

part 'kbroadcast_response.g.dart';

@JsonSerializable()
class KBroadcastResponse extends BaseResponse {
  @JsonKey(name: "kbroadcasts")
  List<KBroadcast>? broadcasts;

  // JSON
  KBroadcastResponse();

  factory KBroadcastResponse.fromJson(Map<String, dynamic> json) =>
      _$KBroadcastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KBroadcastResponseToJson(this);
}