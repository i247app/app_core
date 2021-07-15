import 'package:app_core/helper/date_helper.dart';
import 'package:app_core/helper/kcode.dart';
import 'package:app_core/helper/validate_helper.dart';
import 'package:json_annotation/json_annotation.dart';

int? zzz_atoi(String? z) => z == null ? null : int.parse(z);

String? zzz_itoa(int? num) => num?.toString() ?? null;

int zzz_parseInt(String? z) => z == null || z == "" ? 0 : int.parse(z);

DateTime? zzz_str2Date(String? z) =>
    z == null || z == "" || AppCoreDateHelper.from20FSP(z, isUTC: true) == null
        ? null
        : AppCoreDateHelper.from20FSP(z, isUTC: true)!.toLocal();

String? zzz_date2Str(DateTime? d) =>
    d == null ? null : AppCoreDateHelper.to20FSP(d, toUTC: true);

abstract class AppCoreBaseResponse {
  static const String KTOKEN = "ktoken";
  static const String KSTATUS = "kstatus";
  static const String ERRNO = "errno";
  static const String KMSG = "kmessage"; //"kerrmsg";

  @JsonKey(name: KSTATUS, toJson: zzz_itoa, fromJson: zzz_parseInt)
  int? kstatus;

  @JsonKey(name: KMSG)
  String? kmessage;

  @JsonKey(name: KTOKEN)
  String? ktoken;

  @JsonKey(ignore: true)
  bool get isSuccess => this.kstatus == AppCoreKCode.SUCCESS;

  @JsonKey(ignore: true)
  bool get isNoData => this.kstatus == AppCoreKCode.NO_DATA;

  @JsonKey(ignore: true)
  bool get isError => !this.isSuccess; // NOTE - includes 'isNoData'

  @JsonKey(ignore: true)
  bool get isStrictError => this.isError && !this.isNoData;

  @JsonKey(ignore: true)
  String get prettyMessage => AppCoreValidateHelper.messageFromCode(this.kstatus);
}
