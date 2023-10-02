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

  static const String KACTION = "kaction"; // arbitrary uses - deactivate
  static const String KVALUE = "kvalue";
  static const String KATTRIBUTE = "kattribute";

  static const String KTAGS = "ktags";
  static const String KFTS = "kfts";
  static const String KRANKING = "kranking";
  static const String KRANGE = "krange";

  static const String STATUSES = "statuses";

  static const String KORDER_BY = "korderBy";
  static const String KLIMIT = "klimit";
  static const String KOFFSET = "koffset";

  static const String KSTATUS = "kstatus";
  static const String KMESSAGE = "kmessage";
  static const String KCOUNT = "kcount";

  static const String VALUE_YES = "yes";
  static const String VALUE_NO = "no";
  static const String VALUE_ALL = "all";
  static const String VALUE_ONE = "one";
  static const String VALUE_TUTOR_PERSONAL = "PERSONAL";
  static const String VALUE_TUTOR_AVATAR = "AVATAR";
  static const String VALUE_TUTOR_EDU = "EDU";
  static const String VALUE_TUTOR_ID = "ID";
  static const String VALUE_TUTOR_STUDENT_ID = "STUDENT_ID";
  static const String VALUE_TUTOR_BANK = "BANK";
  static const String VALUE_TUTOR_SKILL = "SKILL";
  static const String VALUE_TUTOR_BIO = "BIO";
  static const String VALUE_TUTOR_VIDEO = "VIDEO";
  static const String VALUE_ADDRESS = "address";
  static const String BOOKING_DEMO_VIDEO = "booking.demo.video";
  static const String TUTOR_ONBOOARD_VIDEO = "tutor.onbooard.video";
  static const String TUTOR_PROFILE_VIDEO = "tutor.profile.video";

  static const String KNAME = "kname";

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

  @JsonKey(name: KACTION)
  String? kaction;

  @JsonKey(name: KATTRIBUTE)
  String? kattribute;

  @JsonKey(name: KVALUE)
  String? kvalue;

  @JsonKey(name: KTAGS)
  String? ktags;

  @JsonKey(name: KFTS)
  String? kfts;

  @JsonKey(name: KRANKING)
  String? kranking;

  @JsonKey(name: KRANGE)
  String? krange;

  @JsonKey(name: STATUSES)
  List<String>? statuses;

  @JsonKey(name: KORDER_BY)
  String? korderBy;

  @JsonKey(name: KLIMIT)
  String? klimit;

  @JsonKey(name: KOFFSET)
  String? koffset;

  @JsonKey(name: KSTATUS)
  String? kstatus;

  @JsonKey(name: KMESSAGE)
  String? kmessage;

  @JsonKey(name: KCOUNT)
  String? kcount;

  @JsonKey(name: KNAME)
  String? kname;
}
