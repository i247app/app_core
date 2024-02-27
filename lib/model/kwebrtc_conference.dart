import 'package:app_core/app_core.dart';
import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/kwebrtc_member.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kwebrtc_conference.g.dart';

@JsonSerializable()
class KWebRTCConference extends KObject {
  static const String APP_GIG = "gig";
  static const String APP_CHAT = "chat";

  @JsonKey(name: "conferenceID")
  String? conferenceID;

  @JsonKey(name: "conferenceKey")
  String? conferenceKey;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "org")
  int? org;

  @JsonKey(name: "startDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? startDate;

  @JsonKey(name: "endDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? endDate;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "latLng")
  String? latLng;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "conferenceCode")
  String? conferenceCode;

  @JsonKey(name: "conferencePass")
  String? conferencePass;

  @JsonKey(name: "conferenceSlug")
  String? conferenceSlug;

  @JsonKey(name: "webRTCMembers")
  List<KWebRTCMember>? webRTCMembers;

  /// Methods
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get meetingName =>
      KStringHelper.isExist(this.refApp) && KStringHelper.isExist(this.refID) ? '(${this.refApp!.toUpperCase()}_${this.refID})' : '';

  // JSON
  KWebRTCConference();

  factory KWebRTCConference.fromJson(Map<String, dynamic> json) => _$KWebRTCConferenceFromJson(json);

  Map<String, dynamic> toJson() => _$KWebRTCConferenceToJson(this);
}
