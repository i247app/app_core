import 'package:app_core/header/kcore_code.dart';
import 'package:app_core/helper/helper.dart';
import 'package:app_core/value/kphrases.dart';

abstract class KValidateHelper {
  static String messageFromCode(int? status) {
    switch (status) {
      case KCoreCode.SUCCESS:
        return KLocaleHelper.isEnglish ? "Success" : "Thành công";
      case 600:
        return KLocaleHelper.isEnglish ? "App Fail" : "App gặp lỗi";
      case KCoreCode.ERROR:
        return KLocaleHelper.isEnglish ? "An error occurred" : "Đã xảy ra lỗi";
      case 622:
        return KLocaleHelper.isEnglish
            ? "Email already exists"
            : "Email đã tồn tại";
      case 621:
        return KLocaleHelper.isEnglish
            ? "Username already exists"
            : "Tài khoản đã tồn tại";
      case 623:
        return KLocaleHelper.isEnglish
            ? "Phone already registered"
            : "Số điện thoại đã tồn tại";
      case KCoreCode.INSUFFICIENT_CREDIT:
        return KPhrases.kstatus808;
      default:
        return KPhrases.anErrorOccurred;
    }
  }
}
