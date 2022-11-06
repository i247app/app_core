import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/response/base_response.dart';

abstract class KObject {
  static const String DOMAIN = "domain";

  static const String REPORT_FLAG = "reportFlag"; // number
  static const String NOTE = "note";
  static const String STATUS_CODE = "statusCode"; // see StatusCode
  static const String CREATE_ID = "createID";
  static const String CREATE_DATE = "createDate";
  static const String MODIFY_ID = "modifyID";
  static const String MODIFY_DATE = "modifyDate";
  static const String IS_VALID = "isValid";

  static const String ACTION = "action"; // arbitrary uses - deactivate
  static const String ATTRIBUTE = "kattribute";

  static const String ORDER_BY = "orderBy";
  static const String LIMIT = "limit";
  static const String OFFSET = "offset";

  static const String KSTATUS = "kstatus";
  static const String KMESSAGE = "kmessage";
  static const String KCOUNT = "kcount";

  @JsonKey(name: DOMAIN)
  String? kdomain;

  @JsonKey(name: REPORT_FLAG)
  String? kreportFlag;

  @JsonKey(name: NOTE)
  String? knote;

  @JsonKey(name: STATUS_CODE)
  String? kstatusCode;

  @JsonKey(name: CREATE_ID)
  String? kcreateID;

  @JsonKey(name: CREATE_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? kcreateDate;

  @JsonKey(name: MODIFY_ID)
  String? kmodifyID;

  @JsonKey(name: MODIFY_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? kmodifyDate;

  @JsonKey(name: IS_VALID)
  String? kisValid;

  @JsonKey(name: ACTION)
  String? action;

  @JsonKey(name: ATTRIBUTE)
  String? kattribute;

  @JsonKey(name: ORDER_BY)
  String? korderBy;

  @JsonKey(name: LIMIT)
  String? klimit;

  @JsonKey(name: OFFSET)
  String? koffset;

  @JsonKey(name: KSTATUS)
  String? kstatus;

  @JsonKey(name: KMESSAGE)
  String? kmessage;

  @JsonKey(name: KCOUNT)
  String? kcount;
}
