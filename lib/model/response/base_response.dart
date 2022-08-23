import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

// ignore: non_constant_identifier_names
int? zzz_atoi(String? z) => z == null ? null : int.parse(z);

// ignore: non_constant_identifier_names
String? zzz_itoa(int? num) => num?.toString() ?? null;

// ignore: non_constant_identifier_names
int zzz_parseInt(String? z) => z == null || z == "" ? 0 : int.parse(z);

// ignore: non_constant_identifier_names
DateTime? zzz_str2Date(String? z) =>
    z == null || z == "" || KDateHelper.from20FSP(z, isUTC: true) == null
        ? null
        : KDateHelper.from20FSP(z, isUTC: true)!.toLocal();

// ignore: non_constant_identifier_names
String? zzz_date2Str(DateTime? d) =>
    d == null ? null : KDateHelper.to20FSP(d, toUTC: true);

// ignore: non_constant_identifier_names
String? zzz_dur2Str(Duration? d) => d == null ? null : "${d.inMilliseconds}";

// ignore: non_constant_identifier_names
Duration? zzz_str2Dur(String? z) {
  int? i = int.tryParse(z ?? "");
  return i == null ? null : Duration(milliseconds: i);
}

// ignore: non_constant_identifier_names
bool? zzz_str2Bool(String? z) =>
    KStringHelper.parseBoolean(z ?? KStringHelper.FALSE);

// ignore: non_constant_identifier_names
String? zzz_bool2Str(bool? b) => KStringHelper.toBooleanCode(b ?? false);

// ignore: non_constant_identifier_names
double? zzz_atod(String? z) => z == null ? null : double.tryParse(z);

// ignore: non_constant_identifier_names
String? zzz_dtoa(double? d) => d?.toString();

abstract class BaseResponse {
  static const String KTOKEN = "ktoken";
  static const String KSTATUS = "kstatus";
  static const String ERRNO = "errno";
  static const String KMSG = "kmessage";

  @JsonKey(name: KSTATUS, toJson: zzz_itoa, fromJson: zzz_parseInt)
  int? kstatus;

  @JsonKey(name: KMSG)
  String? kmessage;

  @JsonKey(name: KTOKEN)
  String? ktoken;

  @JsonKey(ignore: true)
  bool get isSuccess => this.kstatus == KCoreCode.SUCCESS;

  @JsonKey(ignore: true)
  bool get isNoData => this.kstatus == KCoreCode.NO_DATA;

  @JsonKey(ignore: true)
  bool get isError => !this.isSuccess; // NOTE - includes 'isNoData'

  @JsonKey(ignore: true)
  bool get isStrictError => this.isError && !this.isNoData;

  @JsonKey(ignore: true)
  String get prettyMessage => KValidateHelper.messageFromCode(this.kstatus);
}
