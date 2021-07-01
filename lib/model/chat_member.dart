import 'package:app_core/model/user.dart';
import 'package:app_core/helper/util.dart';

class AppCoreChatMember {
  String? chatID;

  String? puid;

  String? kunm;

  String? phone;

  String? firstName;

  String? middleName;

  String? lastName;

  String? avatar;

  String? memberStatus;

  /// Methods
  String? get firstInitial => firstName?.substring(0, 1);

  String get contactName {
    if (this.kunm == null) return this.displayName;
    return "@${kunm!} ${this.displayName}";
  }

  String get displayName =>
      Util.prettyName(
          fnm: firstName ?? "", mnm: middleName ?? "", lnm: lastName ?? "") ??
      this.phone ??
      "";

  String get chatName =>
      this.firstName ?? this.kunm ?? "User ${this.puid ?? "?"}";

  factory AppCoreChatMember.fromUser(AppCoreUser user) => AppCoreChatMember()
    ..puid = user.puid
    ..kunm = user.kunm
    ..firstName = user.firstName
    ..lastName = user.lastName
    ..middleName = user.middleName;

  AppCoreUser toUser() => AppCoreUser()
    ..puid = this.puid
    ..kunm = this.kunm
    ..firstName = this.firstName
    ..lastName = this.lastName
    ..middleName = this.middleName;

  AppCoreChatMember();
}
