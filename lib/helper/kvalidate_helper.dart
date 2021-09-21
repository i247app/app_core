import 'package:app_core/header/kcore_code.dart';

abstract class KValidateHelper {
  static String messageFromCode(int? status) {
    switch (status) {
      case KCoreCode.SUCCESS:
        return "Success";
      case 600:
        return "App Fail";
      case KCoreCode.ERROR:
        return "An error occurred";
      case 622:
        return "Email already exists";
      case 621:
        return "Username already exists";
      case 623:
        return "Phone already registered";
      default:
        return "An error occurred";
    }
  }
}
