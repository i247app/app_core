import 'package:app_core/header/kcore_code.dart';
import 'package:app_core/helper/helper.dart';
import 'package:app_core/lingo/kphrases.dart';

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
        return KPhrases.emailAlreadyUsed;
      case 621:
        return KPhrases.usernameAlreadyUsed;
      case 623:
        return KPhrases.phoneAlreadyUsed;
      case KCoreCode.INSUFFICIENT_FUNDS:
        return KPhrases.insufficientFunds;
      default:
        return KPhrases.anErrorOccurred;
    }
  }
}
