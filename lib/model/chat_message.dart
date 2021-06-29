import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/user.dart';

class AppCoreChatMessage {
  static const String CONTENT_TYPE_TEXT = "text";
  static const String CONTENT_TYPE_IMAGE = "image";

  static const String APP_CONTENT_CHAT = "chat";
  static const String APP_CONTENT_GIG = "gig";
  static const String APP_CONTENT_CUSUP = "cusup";

  String? messageID;

  String? chatID;

  String? puid;

  DateTime? messageDate;

  String? messageType;

  String? message;

  String? messageStatus;

  String? imageData;

  String? refApp;

  String? refID;

  AppCoreUser? user;

  // Helper
  String? localID;

  bool get isLocal => this.localID != null && this.messageID == null;

  bool get isMe => this.puid == SessionData.me?.puid;

  static String generateLocalID() => Util.buildRandomString(8);

  // JSON
  AppCoreChatMessage();
}
