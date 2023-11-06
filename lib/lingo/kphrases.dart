import 'package:app_core/app_core.dart';
import 'package:app_core/lingo/klingo.dart';

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

  static String get directTransfer => _klingo.yak("transfer");

  static String get proxyTransfer => _klingo.yak("bxfr");

  static String get confirm => _klingo.yak("confirm");

  static String get amountMustLowerThanBalance =>
      _klingo.yak("amount_must_lower_than_balance");

  static String get transferRecipient => _klingo.yak("transfer_recipient");

  static String get memoHintText => _klingo.yak("memo_hint_text");

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

  static String get noData => _klingo.yak("no_data");

  static String get noContactFound => _klingo.yak("no_contact_found");

  static String get waitingForOtherUser =>
      _klingo.yak("waiting_for_other_user");

  static String get tapReturnSession => _klingo.yak("tap_return_session");

  static String get sessionEnded => _klingo.yak("session_ended");

  static String get bankTitle => _klingo.yak("bank_title");

  static String get sayHiToX => _klingo.yak("say_hi_to_x");

  static String get hi => _klingo.yak("hi");

  static String get locationPermissionDialogTitle =>
      _klingo.yak("loc_perm_title");

  static String get locationPermissionDialogBody =>
      _klingo.yak("loc_perm_body");

  static String get emailAlreadyUsed => _klingo.yak("email_already_used");

  static String get phoneAlreadyUsed => _klingo.yak("phone_already_used");

  static String get usernameAlreadyUsed => _klingo.yak("username_already_used");

  static String get appFailed => _klingo.yak("app_failed");

  static String get success => _klingo.yak("success");

  static String get grade => _klingo.yak("grade");

  static String get headstart => _klingo.yak("headstart");

  static String get headstartDoc => _klingo.yak("headstart_documents");

  static String get classDoc => _klingo.yak("class_documents");

  static String get math => _klingo.yak("math");

  static String get english => _klingo.yak("english");

  static String get vietnamese => _klingo.yak("vietnamese");

  static String get district => _klingo.yak("district");

  static String get ward => _klingo.yak("ward");

  static String get noWifi => _klingo.yak("no_wifi");

  static String get resendCode => _klingo.yak("resend_code");

  static String get preSchool => _klingo.yak("pre_school");

  static String get kindergarten => _klingo.yak("kindergarten");

  static String get cancel => "Cancel";

  static String get ok => "Ok";

  static String get newUpdate => _klingo.yak("new_update");

  static String get updateContent => _klingo.yak("update_content");

  static String get skip => _klingo.yak("skip");

  static String get update => _klingo.yak("update");

  static String get passcodeSetting => _klingo.yak("passcode_setting");

  static String get enterCurrentPasscode => _klingo.yak("enter_current_passcode");

  static String get reEnterPasscode => _klingo.yak("re_enter_passcode");

  static String get passcodeNotMatch => _klingo.yak("passcode_not_match");

  static String get enterPasscode => _klingo.yak("enter_passcode");

  static String get webRTCCallLeave => _klingo.yak("web_rtc_call_leave");

  static String get webRTCCallEnd => _klingo.yak("web_rtc_call_end");

  static String get webRTCCallNo => _klingo.yak("web_rtc_call_no");

  static String get webRTCCallYes => _klingo.yak("web_rtc_call_yes");

  static String get webRTCMeeting => _klingo.yak("web_rtc_meeting");

  static String get webRTCCode => _klingo.yak("web_rtc_code");

  static String get webRTCPass => _klingo.yak("web_rtc_pass");

  static String get copied => _klingo.yak("copied");
}
