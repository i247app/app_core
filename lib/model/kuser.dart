import 'package:app_core/helper/util.dart';
import 'package:json_annotation/json_annotation.dart';

class KUser {
  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "kunm")
  String? kunm;

  @JsonKey(name: "fone")
  String? phone;

  @JsonKey(name: "foneCode")
  String? phoneCode;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "middleName")
  String? middleName;

  @JsonKey(name: "lastName")
  String? lastName;

  /*
   * Address
   */
  @JsonKey(name: "addressLine1")
  String? address;

  @deprecated
  @JsonKey(name: "addressLine2")
  String? address2;

  @deprecated
  @JsonKey(name: "city")
  String? city;

  @deprecated
  @JsonKey(name: "stateCode")
  String? state;

  @deprecated
  @JsonKey(name: "zipCode")
  String? zip;

  @JsonKey(name: "countryCode")
  String? countryCode;

  @JsonKey(name: "displayImg")
  String? displayImg;

  @JsonKey(name: "avatar")
  String? avatarURL;

  @JsonKey(name: "avatarData")
  String? avatarImageData;

  @JsonKey(ignore: true)
  String? get contactName {
    if (kunm == null) return this.fullName;
    return "@${kunm!} ${this.fullName}";
  }

  // TODO - fix reward user (non-regis phone only)
  String? get fullName =>
      KUtil.prettyName(
          fnm: firstName ?? "", mnm: middleName ?? "", lnm: lastName ?? "") ??
      phone;

  String get prettyFone =>
      KUtil.prettyFone(foneCode: this.phoneCode ?? "", number: phone ?? "");

  String get firstInitial => firstName?.substring(0, 1) ?? "";
}
