import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/kuser.dart';

part 'kp2p_session.g.dart';

@JsonSerializable()
class KP2PSession {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "chatID")
  String? chatID;

  @JsonKey(name: "refApp")
  String? refApp;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "adminPUID")
  String? adminPUID;

  @JsonKey(name: "adminName")
  String? adminName;

  @JsonKey(name: "adminAvatarURL")
  String? adminAvatarURL;

  /// Methods
  factory KP2PSession.fromUser(KUser user) => KP2PSession()
    ..adminPUID = user.puid
    ..adminName = user.fullName
    ..adminAvatarURL = user.avatarURL;

  // JSON
  KP2PSession();

  factory KP2PSession.fromJson(Map<String, dynamic> json) =>
      _$KP2PSessionFromJson(json);

  Map<String, dynamic> toJson() => _$KP2PSessionToJson(this);
}
