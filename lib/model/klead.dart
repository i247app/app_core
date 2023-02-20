import 'package:app_core/model/kaddress.dart';
import 'package:app_core/model/klat_lng.dart';
import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'klead.g.dart';

@JsonSerializable()
class KLead extends KObject {
  static const String ACTION_LIST = "list";

  static const String CHOT_STATUS_YES = "Y";
  static const String CHOT_STATUS_PENDING = "P";
  static const String CHOT_STATUS_MAYBE = "M";
  static const String CHOT_STATUS_NO = "N";

  static const String LEAD_STATUS_OPEN = "OPEN";
  static const String LEAD_STATUS_CLOSE = "CLOSE";

  static const String LEAD_TYPE_CUSTOMER = "CUSTOMER";
  static const String LEAD_TYPE_TUTOR = "TUTOR";
  static const String LEAD_TYPE_TEACHER = "TEACHER";

  static const String LEAD_INTEREST_HOMEWORK = "DAY_KEM";
  static const String LEAD_INTEREST_EXAM_TUTORING = "LUYEN_THI";
  static const String LEAD_INTEREST_GRADE = "LOP";

  static const String LEAD_ID = "leadID";
  static const String OWNER_ID = "ownerID";
  static const String CONTACT_ID = "contactID";
  static const String BUSINESS_NAME = "businessName";
  static const String CONTACT_NAME = "contactName";
  static const String PHONE_NUMBER = "fone";
  static const String PHONE_NUMBER_CODE = "foneCode";
  static const String EMAIL = "email";
  static const String ADDRESS = "addressLine";
  static const String LAT_LNG = "latLng";
  static const String LEAD_NOTE = "leadNote";
  static const String LEAD_STATUS = "leadStatus";
  static const String LEAD_DATE = "leadDate";
  static const String KUID = "kuid";
  static const String INTERESTS = "interests";
  static const String USER_TYPE = "userType";
  static const String GIG_MEDIUM = "mediumType";
  static const String GRADE = "grade";
  static const String BY_ID = "byID";
  static const String BY_DATE = "byDate";
  static const String ADDRESSES = "addresses";
  // customer chot info
  static const String CHOT_DATE = "chotDate";
  static const String CHOT_STATUS = "chotStatus";
  //
  // static const String CHOT_STATUS_YES = "Y";
  // static const String CHOT_STATUS_NO = "N";

  static const String STATUS_YES = "YES";
  static const String STATUS_NO = "NO";
  static const String STATUS_FOLLOW_UP = "FOLLOW_UP";
  static const String STATUS_NONE = "NONE";
  static const String PRIORITY = "leadPriority";
  static const String LEAD_TYPE = "leadType";

  @JsonKey(name: LEAD_ID)
  String? id;

  @JsonKey(name: OWNER_ID)
  String? ownerID;

  @JsonKey(name: CONTACT_ID)
  String? contactID;

  @JsonKey(name: BUSINESS_NAME)
  String? businessName;

  @JsonKey(name: CONTACT_NAME)
  String? contactName;

  @JsonKey(name: PHONE_NUMBER)
  String? phoneNumber;

  @JsonKey(name: PHONE_NUMBER_CODE)
  String? phoneNumberCode;

  @JsonKey(name: EMAIL)
  String? email;

  @JsonKey(name: ADDRESS)
  String? address;

  @JsonKey(name: LEAD_NOTE)
  String? leadNote;

  @JsonKey(name: LEAD_STATUS)
  String? leadStatus;

  @JsonKey(name: LEAD_DATE)
  String? leadDate;

  @JsonKey(name: KUID)
  String? kuid;

  @JsonKey(name: USER_TYPE)
  String? userType;

  @JsonKey(name: GIG_MEDIUM)
  String? gigMedium;

  @JsonKey(name: GRADE)
  String? grade;

  @JsonKey(name: LAT_LNG)
  KLatLng? latLng;

  @JsonKey(name: INTERESTS)
  List<String>? interests;

  @JsonKey(name: BY_ID)
  String? byID;

  @JsonKey(name: BY_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? byDate;

  @JsonKey(name: ADDRESSES)
  List<KAddress>? addresses;

  @JsonKey(name: CHOT_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? chotDate;

  @JsonKey(name: CHOT_STATUS)
  String? chotStatus;

  @JsonKey(name: PRIORITY, toJson: zzz_itoa, fromJson: zzz_atoi)
  int? priority;

  @JsonKey(name: LEAD_TYPE)
  String? leadType;

  // JSON
  KLead();

  factory KLead.fromJson(Map<String, dynamic> json) => _$KLeadFromJson(json);

  Map<String, dynamic> toJson() => _$KLeadToJson(this);
}
