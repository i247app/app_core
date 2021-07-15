import 'package:app_core/model/user_session.dart';

abstract class AppCoreSessionInitData {
  String? get initSessionToken;
  KUserSession? get initUserSession;
}