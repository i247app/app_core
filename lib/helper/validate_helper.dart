import 'package:app_core/helper/kcode.dart';

abstract class ValidateHelper {
  static String messageFromCode(int? status) {
    switch (status) {
      case KCode.SUCCESS:
        return "Success";
      case 600:
        return "App Fail";
      case KCode.ERROR:
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
