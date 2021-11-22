import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kaddress.dart';

part 'business_member.g.dart';

@JsonSerializable()
class BusinessMember extends KUser {
  static const String ROLE_ADMIN = "ADMIN";
  static const String ROLE_GM = "GM";
  static const String ROLE_MANAGER = "MANAGER";
  static const String ROLE_STAFF = "STAFF";

  // NOTE super.puid is the main businessMember id

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "buid")
  String? buid;

  @JsonKey(name: "storeID")
  String? storeID;

  @JsonKey(name: "storeNO")
  String? storeNO;

  // member
  @JsonKey(name: "memberPUID")
  String? memberPUID;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "middleName")
  String? middleName;

  @JsonKey(name: "lastName")
  String? lastName;

  @JsonKey(name: "role")
  String? role;

  @JsonKey(name: "memberStatus")
  String? memberStatus;

  @JsonKey(name: "activeStatus")
  String? activeStatus;

  // TODO remove here. use KSessionData.activeTokename
  @JsonKey(name: "tokenName")
  String? tokenName;

  @JsonKey(name: "businessName")
  String? businessName;

  bool isActive() => KStringHelper.parseBoolean(this.activeStatus ?? "");

  String get fullName =>
      phone ??
      KUtil.prettyName(
          fnm: firstName ?? "", mnm: middleName ?? "", lnm: lastName ?? "") ??
      "";

  // JSON
  BusinessMember();

  factory BusinessMember.fromJson(Map<String, dynamic> json) =>
      _$BusinessMemberFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessMemberToJson(this);
}
