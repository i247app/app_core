import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kcredit_transaction.g.dart';

// The KCreditTransaction object here is actually a transaction line of a double entry model, two lines (CR/DR)
// This object here is assPUID point of view - credits/debits for this assPUID
// Double entry transactions - note refPUID is really fwdPUID on server
// txID lineID lineType xfrType assPUID refPUID amt          tokenName
// 100  200     DR      DXFR    501     503     -5.12345678  CHAO      // user 501 sent
// 100  201     CR      DXFR    503     501      5.12345678  CHAO      // user 503 received
// - lineType (CR/DR) direction amount. Note - DR negative amount
// - xfrType (DXFR/EXFR/AWARD) are app transfer type

@JsonSerializable()
class KCreditTransaction {
  static const String LINE_TYPE_CREDIT = "CR";

  @JsonKey(name: "txID") // grouping of lines
  String? txID;

  @JsonKey(name: "lineID") // pk unique
  String? lineID;

  @JsonKey(name: "lineDate")
  String? lineDate;

  // DR/CR
  @JsonKey(name: "lineType")
  String? lineType;

  // AWARD DXFR EXFR DEP WDL etc
  @JsonKey(name: "xfrType")
  String? xfrType;

  @JsonKey(name: "amount")
  String? amount;

  @JsonKey(name: "tokenName")
  String? tokenName;

  @JsonKey(name: "puid") // associate or session user
  String? puid;

  @JsonKey(name: "poiPUID") // poi is the fwd not ref on server
  String? poiPUID;

  @JsonKey(name: "poiKUNM")
  String? poiKUNM;

  @JsonKey(name: "poiFirstName")
  String? poiFirstName;

  @JsonKey(name: "poiMiddleName")
  String? poiMiddleName;

  @JsonKey(name: "poiLastName")
  String? poiLastName;

  @JsonKey(name: "poiFone")
  String? poiFone;

  @JsonKey(name: "poiBusinessName")
  String? poiBusinessName;

  @JsonKey(ignore: true)
  String get atName => this.poiKUNM != null ? "@${this.poiKUNM}" : "";

  @JsonKey(ignore: true)
  String get prettyName {
    String z = this.poiBusinessName ??
        KUtil.prettyName(
            fnm: this.poiFirstName ?? "",
            mnm: this.poiMiddleName ?? "",
            lnm: this.poiLastName ?? "") ??
        this.poiFone ??
        "";

    // special transaction poiFone for fee,dep, wdl etc (1,2,5,6)
    switch (z) {
      case "1":
        z = ""; // "Fee";
        break;
      case "2":
        z = ""; // "Escrow";
        break;
      case "5":
        z = ""; // "Deposit";
        break;
      case "6":
        z = ""; // "Withdrawal";
        break;
      default:
        break;
    }

    return z;
  }

  @JsonKey(ignore: true)
  String get prettyXFRDescription => KUtil.prettyXFRDescription(
      lineType: this.lineType, xfrType: this.xfrType);

  @JsonKey(ignore: true)
  String get prettyMoney => KUtil.prettyMoney(
      amount: this.amount ?? "", tokenName: this.tokenName ?? "");

  // JSON
  KCreditTransaction();

  factory KCreditTransaction.fromJson(Map<String, dynamic> json) =>
      _$KCreditTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$KCreditTransactionToJson(this);
}
