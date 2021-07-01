import 'package:app_core/helper/util.dart';

class AppCoreUser {
  String? puid;

  String? kunm;

  String? phone;

  String? phoneCode;

  String? email;

  String? firstName;

  String? middleName;

  String? lastName;

  /*
   * Address
   */
  String? address;

  @deprecated
  String? address2;

  @deprecated
  String? city;

  @deprecated
  String? state;

  @deprecated
  String? zip;

  String? countryCode;

  String? displayImg;

  String? avatar;

  String? avatarImageData;

  String? businessName;

  String? get contactName {
    if (kunm == null) return this.fullName;
    return "@${kunm!} ${this.fullName}";
  }

  // TODO - fix reward user (non-regis phone only)
  String? get fullName =>
      businessName ??
      Util.prettyName(
          fnm: firstName ?? "", mnm: middleName ?? "", lnm: lastName ?? "") ??
      phone;

  String get prettyFone =>
      Util.prettyFone(foneCode: this.phoneCode ?? "", number: phone ?? "");

  String get firstInitial => firstName?.substring(0, 1) ?? "";

  // JSON
  AppCoreUser();
}
