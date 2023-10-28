import 'package:app_core/app_core.dart';
import 'package:app_core/model/kwebrtc_conference.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_response.dart';

part 'webrtc_conference_action_response.g.dart';

@JsonSerializable()
class WebRTCConferenceActionResponse extends BaseResponse {
  @JsonKey(name: "webRTCConferences")
  List<KWebRTCConference>? webRTCConferences;

  // JSON
  WebRTCConferenceActionResponse();

  factory WebRTCConferenceActionResponse.fromJson(Map<String, dynamic> json) =>
      _$WebRTCConferenceActionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WebRTCConferenceActionResponseToJson(this);
}
