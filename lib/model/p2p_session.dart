import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/user.dart';

@JsonSerializable()
class AppCoreP2PSession {
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
  factory AppCoreP2PSession.fromUser(AppCoreUser user) => AppCoreP2PSession()
    ..adminPUID = user.puid
    ..adminName = user.fullName
    ..adminAvatarURL = user.avatarURL;

  // JSON
  AppCoreP2PSession();
}
