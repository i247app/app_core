import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kobject.dart';

part 'kwebrtc_member.g.dart';

@JsonSerializable()
class KWebRTCMember extends KObject {
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

  @JsonKey(name: "memberID")
  String? memberID;

  @JsonKey(name: "memberKey")
  String? memberKey;

  @JsonKey(name: "nicKey")
  String? nicKey;

  @JsonKey(name: "fnm")
  String? fnm;

  @JsonKey(name: "mnm")
  String? mnm;

  @JsonKey(name: "lnm")
  String? lnm;

  // JSON
  KWebRTCMember();

  factory KWebRTCMember.fromJson(Map<String, dynamic> json) => _$KWebRTCMemberFromJson(json);

  Map<String, dynamic> toJson() => _$KWebRTCMemberToJson(this);
}
