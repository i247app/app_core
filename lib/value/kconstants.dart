import 'package:app_core/helper/klocale_helper.dart';
import 'package:app_core/model/kcountry_data.dart';

abstract class KConstants {
  /// Project
  // static const String appName = "Schoolbird";
  static const String googleMapsApiKey =
      "AIzaSyDGIjAz96Y0gLNUz6Sv-4RUmEmn4iyI9rU";

  /* Phone */
  static const String phonePlaceholderUSA = "eg 5553431212";
  static const String phonePlaceholderVietnam = "vd 0901234567";

  // TODO - get google_map_api_key from server on login/resume session
  // map dvl key gen
  // keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

  /// Phone code
  static const String countryPhoneCodeUSA = "1";
  static const String countryPhoneCodeVietnam = "84";
  static const List<String> countryPhoneCodes = <String>[
    countryPhoneCodeVietnam,
    countryPhoneCodeUSA,
  ];

  static String get defaultPhoneCountryCode =>
      KLocaleHelper.currentLocale.country == countryUsaCode
          ? countryPhoneCodeUSA
          : countryPhoneCodeVietnam;

  /// Country
  static const String countryUsaCode = KLocaleHelper.COUNTRY_US;
  static const String countryVietnamCode = KLocaleHelper.COUNTRY_VN;
  static const String countryUsaLabel = "United States";
  static const String countryVietnamLabel = "Vietnam";

  static final List<KCountryData> countries = [
    KCountryData.raw(
      code: countryUsaCode,
      label: countryUsaLabel,
      phoneCode: countryPhoneCodeUSA,
    ),
    KCountryData.raw(
      code: countryVietnamCode,
      label: countryVietnamLabel,
      phoneCode: countryPhoneCodeVietnam,
    ),
  ];

  static final List<String> banksUsa = [
    "JPMorgan Chase & Co",
    "Bank of America Corp",
    "Wells Fargo & Co",
    "Citigroup Inc",
    "U.S. Bancorp",
    "Truist Bank",
    "PNC Financial Services Group Inc",
    "TD Group US Holdings LLC",
    "Bank of New York Mellon Corp",
    "Capital One Financial Corp",
    "Goldman Sachs Group Inc",
    "State Street Corp",
    "Fifth Third Bank",
    "HSBC",
    "Citizens Financial Group",
  ];
  static final List<String> banksVietnam = [
    "An Binh Commercial Joint stock  Bank",
    "Asia Commercial Bank",
    "Vienam Bank for Agriculture and Rural Development",
    "ANZ Bank",
    "BANGKOK  BANK",
    "VietNam national Financial switching Joint Stock Company",
    "Baoviet Joint Stock Commercial Bank",
    "BANK OF CHINA",
    "Bank for investment and development of Cambodia HCMC",
    "Bank for investment and development of Cambodia HN",
    "Bank for Investment and Development of Vietnam",
    "Bank of Paris and the Netherlands HCMC",
    "BNP Paribas Ha Noi",
    "Bank of Communications",
    "NH BPCEIOM HCMC",
    "BANK OF TOKYO - MITSUBISHI UFJ - TP HCM",
    "BANK OF TOKYO - MITSUBISHI UFJ - HN",
    "Credit Agricole Corporate and Investment Bank",
    "Commonwealth Bank of Australia",
    "China Construction Bank Corporation",
    "The Chase Manhattan Bank",
    "CIMB Bank Vietnam Limited",
    "CitiBank HCM",
    "Citibank Ha Noi",
    "Co-Operation Bank of Viet Nam",
    "The ChinaTrust Commercial Bank HCMC",
    "Cathay United Bank",
    "DEUTSCHE BANK",
    "DBS Bank Ltd",
    "Dong A Commercial Joint stock Bank",
    "Vietnam Export Import Commercial Joint Stock Bank",
    "First Commercial Bank",
    "First Commercial Bank Ha Noi",
    "Global Petro Commercial Joint Stock Bank",
    "Housing Development Bank",
    "Hong Leong Bank Viet Nam",
    "Hua Nan Commercial Bank",
    "The HongKong and Shanghai Banking Corporation",
    "NH The Hongkong and Shanghai",
    "Industrial Bank of Korea",
    "ICB of China CN Ha Noi",
    "Indovina Bank",
    "Kho Bac Nha Nuoc",
    "Korea Exchange Bank",
    "Kien Long Commercial Joint Stock Bank",
    "Kookmin Bank",
    "Lien Viet Post Bank",
    "Maritime Bank",
    "Maybank",
    "Military Commercial Joint stock Bank",
    "Malayan Banking Berhad",
    "Mizuho Corporate Bank - TP HCM",
    "Mega ICBC Bank",
    "Mizuho Bank",
    "Nam A Commercial Joint stock Bank",
    "North Asia Commercial Joint Stock Bank",
    "National Citizen Bank",
    "Oversea - Chinese Banking Corporation",
    "Ocean Bank",
    "Orient Commercial Joint Stock Bank",
    "Petrolimex group commercial Joint stock Bank",
    "PVcombank",
    "Quy tin dung co so",
    "Saigon Thuong Tin Commercial Joint Stock Bank",
    "Saigon Bank for Industry and Trade",
    "State Bank of Vietnam",
    "Saigon Commercial Joint Stock Bank",
    "Standard Chartered Bank",
    "Standard Chartered Bank HN",
    "The Shanghai Commercial & Savings Bank CN Dong Nai",
    "South East Asia Commercial Joint stock  Bank",
    "Saigon - Hanoi Commercial Joint Stock Bank",
    "Shinhan Bank",
    "The Siam Commercial Public Bank",
    "Sumitomo Mitsui Banking Corporation HCMC",
    "Sumitomo Mitsui Banking Corporation HN",
    "SinoPac Bank",
    "Vietnam Technological and Commercial Joint stock Bank",
    "Taipei Fubon Commercial Bank Ha Noi",
    "Taipei Fubon Commercial Bank TP Ho Chi Minh",
    "United Oversea Bank",
    "Vietnam Bank for Social Policies",
    "Vietnam Development Bank",
    "Vietnam International Commercial Joint Stock Bank",
    "VID public",
    "Ngan hang Viet Hoa",
    "Viet A Commercial Joint Stock Bank",
    "Vietnam Thương tin Commercial Joint Stock Bank",
    "BanViet Commercial Jont stock Bank",
    "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
    "Vietnam Joint Stock Commercial Bank for Industry and Trade",
    "Vietnam Construction Bank",
    "Vietnam prosperity Joint stock commercial Bank",
    "Vietnam - Russia Bank",
    "Ngan hang Vung Tau",
    "Woori BANK HCMC",
    "WOORI BANK Hanoi",
  ];

  static List<String> get banks =>
      KLocaleHelper.currentLocale.country == countryUsaCode
          ? banksUsa
          : banksVietnam;

  static List<String> get countryCodes => countries.map((c) => c.code).toList();
}
