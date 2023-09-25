import 'dart:convert';

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
KUser? zzz_json2User(Map<String, dynamic>? m) =>
    m == null ? null : KUser.fromJson(m);

// ignore: non_constant_identifier_names
Map<String, dynamic>? zzz_user2JSON(KUser? u) => u?.toJson();

// ignore: non_constant_identifier_names
String? zzz_dur2Str(Duration? d) => d == null ? null : "${d.inMilliseconds}";

// ignore: non_constant_identifier_names
Duration? zzz_str2Dur(String? z) {
  int? i = int.tryParse(z ?? "");
  return i == null ? null : Duration(milliseconds: i);
}

// ignore: non_constant_identifier_names
bool? zzz_str2Bool(String? z) =>
    z == null ? null : KStringHelper.parseBoolean(z);

// ignore: non_constant_identifier_names
String? zzz_bool2Str(bool? b) =>
    b == null ? null : KStringHelper.toBooleanCode(b);

// ignore: non_constant_identifier_names
double? zzz_atod(String? z) => z == null ? null : double.tryParse(z);

// ignore: non_constant_identifier_names
String? zzz_dtoa(double? d) => d?.toString();

// ignore: non_constant_identifier_names
String? zzz_json2Str(Map<String, dynamic>? m) =>
    m == null ? null : json.encode(m);

// ignore: non_constant_identifier_names
Map<String, dynamic>? zzz_str2JSON(String? z) =>
    z == null ? null : json.decode(z);

// ignore: non_constant_identifier_names
String? zzz_list2Str(List<String>? m) =>
    m == null ? null : json.encode(m);

// ignore: non_constant_identifier_names
List<String>? zzz_str2List(String? z) =>
    z == null ? null : json.decode(z);

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

  /// Methods
  @JsonKey(ignore: true)
  bool get isSuccess => kstatus == KCoreCode.SUCCESS;

  @JsonKey(ignore: true)
  bool get isNotSuccess => !isSuccess;

  @JsonKey(ignore: true)
  bool get isNoData => kstatus == KCoreCode.NO_DATA;

  @deprecated
  @JsonKey(ignore: true)
  bool get isError => !isSuccess; // NOTE - includes 'isNoData'

  @JsonKey(ignore: true)
  bool get isStrictError => !isSuccess && !isNoData;

  @JsonKey(ignore: true)
  String get prettyMessage =>
      kmessage ?? KValidateHelper.messageFromCode(kstatus);
}
