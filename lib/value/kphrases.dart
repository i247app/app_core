import 'package:app_core/app_core.dart';
import 'package:app_core/helper/klingo.dart';

abstract class KPhrases {
  static late final KLingo _klingo;

  static bool _isInit = false;

  static Future init() async {
    if (_isInit) return;
    _isInit = true;

    _klingo = KLingo(
      [
        KLingoDictionary(
          language: KLocaleHelper.LANGUAGE_EN,
          dictFilepath: KAssets.I18N_EN,
        ),
        KLingoDictionary(
          language: KLocaleHelper.LANGUAGE_VI,
          dictFilepath: KAssets.I18N_VN,
        ),
      ],
      fallbackLanguage: KLocaleHelper.LANGUAGE_EN,
    );
    await _klingo.load(package: 'app_core');
    _isInit = true;
  }

  /// Localized strings
  static String get anErrorOccurred => _klingo.yak("an_error_occurred");

  static String get insufficientFunds => _klingo.yak("insufficient_funds");

  static String get insufficientCredits => _klingo.yak("insufficient_credits");

  static String get paymentMethod => _klingo.yak("payment_method");

  static String get withdrawal => _klingo.yak("withdrawal");

  static String get deposit => _klingo.yak("deposit");

  static String get transfer => _klingo.yak("transfer");

  static String get confirm => _klingo.yak("confirm");

  static String get accountName => _klingo.yak("account_name");

  static String get accountNumber => _klingo.yak("account_number");

  static String get bank => _klingo.yak("bank");

  static String get amount => _klingo.yak("amount");

  static String get accountNamePlaceHolder =>
      _klingo.yak("account_name_place_holder");

  static String get accountNumberPlaceHolder =>
      _klingo.yak("account_number_place_holder");

  static String get amountPlaceHolder => _klingo.yak("amount_place_holder");

  static String get student => _klingo.yak("student");

  static String get parent => _klingo.yak("parent");

  static String get tutor => _klingo.yak("tutor");

  static String get user => _klingo.yak("user");

  static String get bankAccount => _klingo.yak("bank_account");

  static String get gigListReadyAndWaiting =>
      _klingo.yak("gig_list_ready_waiting");

  static String get noTransactionsFound => _klingo.yak("no_transactions_found");

  static String get waitingForOtherUser =>
      _klingo.yak("waiting_for_other_user");

  static String get sessionEnded => _klingo.yak("session_ended");

  static String get bankTitle => _klingo.yak("bank_title");

  static String get sayHiToX => _klingo.yak("say_hi_to_x");

  static String get hi => _klingo.yak("hi");

  static String get emailAlreadyUsed => _klingo.yak("email_already_used");

  static String get phoneAlreadyUsed => _klingo.yak("phone_already_used");

  static String get usernameAlreadyUsed => _klingo.yak("username_already_used");

  static String get appFailed => _klingo.yak("app_failed");

  static String get success => _klingo.yak("success");
}
