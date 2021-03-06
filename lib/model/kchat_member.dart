import 'package:app_core/model/kuser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/helper/kutil.dart';

part 'kchat_member.g.dart';

@JsonSerializable()
class KChatMember {
  @JsonKey(name: "chatID")
  String? chatID;

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "kunm")
  String? kunm;

  @JsonKey(name: "fone")
  String? phone;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "middleName")
  String? middleName;

  @JsonKey(name: "lastName")
  String? lastName;

  @JsonKey(name: "avatar")
  String? avatar;

  @JsonKey(name: "memberStatus")
  String? memberStatus;

  @JsonKey(name: "domain")
  String? domain;

  @JsonKey(name: "refID")
  String? refID;

  @JsonKey(name: "refApp")
  String? refApp;

  /// Methods
  @JsonKey(ignore: true)
  String? get firstInitial => firstName?.substring(0, 1);

  @JsonKey(ignore: true)
  String get contactName {
    if (this.kunm == null) return this.displayName;
    return "@${kunm!} ${this.displayName}";
  }

  @JsonKey(ignore: true)
  String get displayName =>
      KUtil.prettyName(fnm: firstName, mnm: middleName, lnm: lastName) ??
      this.phone ??
      "";

  @JsonKey(ignore: true)
  String get chatName =>
      this.firstName ?? this.kunm ?? "KUser ${this.puid ?? "?"}";

  KUser toUser() => KUser()
    ..puid = this.puid
    ..kunm = this.kunm
    ..firstName = this.firstName
    ..lastName = this.lastName
    ..middleName = this.middleName
    ..avatarURL = this.avatar;

  factory KChatMember.fromUser(KUser user) => KChatMember()
    ..puid = user.puid
    ..kunm = user.kunm
    ..firstName = user.firstName
    ..lastName = user.lastName
    ..middleName = user.middleName;

  // JSON
  KChatMember();

  factory KChatMember.fromJson(Map<String, dynamic> json) =>
      _$KChatMemberFromJson(json);

  Map<String, dynamic> toJson() => _$KChatMemberToJson(this);
}
