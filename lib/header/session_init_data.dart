import 'package:app_core/model/user_session.dart';

abstract class KSessionInitData {
  String? get initSessionToken;
  KUserSession? get initUserSession;
}