import 'package:app_core/helper/session_data.dart';
import 'package:app_core/rem/rem.dart';

abstract class AppCoreREMGenerator {
  static const String TAG = "REMGenerator";

  static String buildAppAction(AppCoreREMPath remPath) =>
      "${remPath.head}.${remPath.full}";

  static Map<String, dynamic> getMyData() => getUserData();

  static Map<String, dynamic> getUserData() {
    String puid = AppCoreSessionData.me?.puid ?? "";
    String username = AppCoreSessionData.me?.kunm ?? "";

    Map<String, dynamic> json = Map<String, dynamic>();
    try {
      json[AppCoreREM.APP] = AppCoreREM.USER;
      json["puid"] = puid;
      json["username"] = username;
    } catch (e) {
      // e.printStackTrace();
      print(e);
    }
    return json;
  }
}
