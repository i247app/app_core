import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'xfr_ticket.g.dart';

@JsonSerializable()
class XFRTicket {
  // required in params
  static const String BY_PUID = "byPUID";
  static const String SND_PUID = "sndKUID";
  static const String RCV_PUID = "rcvPUID"; // to priority 1
  static const String RCV_KUNM = "rcvKUNM"; // or priority 2
  static const String RCV_EMAIL = "rcvEmail"; // or priority 3
  static const String RCV_FONE = "rcvFone"; // or priority 4
  static const String AMOUNT = "amount";
  static const String TOKEN_NAME = "tokenName";
  static const String MEMO = "memo";

  // optional in params
  static const String XFR_ID = "xfrID";
  static const String XFR_TYPE = "xfrType"; // AWARD DXFR EXFR DEP WDL XFR etc

  static const String XFR_DATE = "xfrDate";
  static const String MESSAGE = "message"; // tx preview message
  static const String PROMO_CODE = "promoCode";
  static const String FEE_RATE = "feeRate";
  static const String FEE_AMOUNT = "feeAmount";

  // dig attributes for transaction lines
  static const String BY_KUID = "byKUID";
  static const String SND_KUID = "sndKUID";
  static const String SND_KAID = "sndKAID";
  static const String RCV_KUID = "rcvKUID";
  static const String RCV_KAID = "rcvKAID";

  static const String IS_AUTO_CREATE = "isAutoCreate";

  @JsonKey(name: BY_PUID)
  String? byPUID;

  @JsonKey(name: SND_PUID)
  String? sndKUID;

  @JsonKey(name: RCV_PUID)
  String? rcvPUID;

  @JsonKey(name: RCV_KUNM)
  String? rcvKUNM;

  @JsonKey(name: RCV_EMAIL)
  String? rcvEmail;

  @JsonKey(name: RCV_FONE)
  String? rcvFone;

  @JsonKey(name: AMOUNT)
  String? amount;

  @JsonKey(name: TOKEN_NAME)
  String? tokenName;

  @JsonKey(name: MEMO)
  String? memo;

  @JsonKey(name: XFR_ID)
  String? xfrID;

  @JsonKey(name: XFR_TYPE)
  String? xfrType;

  @JsonKey(name: XFR_DATE)
  String? xfrDate;

  @JsonKey(name: MESSAGE)
  String? message;

  @JsonKey(name: PROMO_CODE)
  String? promoCode;

  @JsonKey(name: FEE_RATE)
  String? feeRate;

  @JsonKey(name: FEE_AMOUNT)
  String? feeAmount;

  @JsonKey(name: BY_KUID)
  String? byKUID;

  @JsonKey(name: SND_KAID)
  String? sndKAID;

  @JsonKey(name: RCV_KUID)
  String? rcvKUID;

  @JsonKey(name: RCV_KAID)
  String? rcvKAID;

  @JsonKey(name: IS_AUTO_CREATE, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isAutoCreate;

  // JSON
  XFRTicket();

  factory XFRTicket.fromJson(Map<String, dynamic> json) =>
      _$XFRTicketFromJson(json);

  Map<String, dynamic> toJson() => _$XFRTicketToJson(this);
}
