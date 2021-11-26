import 'package:app_core/header/kcore_code.dart';
import 'package:app_core/helper/helper.dart';
import 'package:app_core/value/kphrases.dart';

abstract class KValidateHelper {
  static String messageFromCode(int? status) {
    switch (status) {
      case KCoreCode.SUCCESS:
        return KPhrases.success;
      case 600:
        return KPhrases.appFailed;
      case KCoreCode.ERROR:
        return KPhrases.anErrorOccurred;
      case 622:
        return KPhrases.emailAlreadyExits;
      case 621:
        return KPhrases.usernameAlreadyExits;
      case 623:
        return KPhrases.phoneAlreadyExits;
      case KCoreCode.INSUFFICIENT_CREDIT:
        return KPhrases.kstatus808;
      default:
        return KPhrases.anErrorOccurred;
    }
  }
}
