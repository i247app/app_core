import 'package:app_core/model/kuser_session.dart';

abstract class KSessionInitData {
  String? get initSessionToken;
  KUserSession? get initUserSession;
}