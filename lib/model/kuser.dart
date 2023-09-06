import 'package:app_core/app_core.dart';
import 'package:app_core/model/kaddress.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kobject.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kuser.g.dart';

@JsonSerializable()
class KUser extends KObject {
  static const String ACTION_ADD = "add";
  static const String ACTION_LIST = "list";
  static const String ACTION_MODIFY = "modify";
  static const String ACTION_REMOVE = "remove";
  static const String GIG_COUNT = "gigCount";
  static const String PUID = "puid";
  static const String KUNM = "kunm";
  static const String FONE = "fone";
  static const String FONE_CODE = "foneCode";
  static const String EMAIL = "email";
  static const String CV_TEXT = "cvText";

  // static const String IS_ONLINE= "isOnline";
  static const String IS_WORKING = "isWorking";

  @JsonKey(name: IS_WORKING, fromJson: zzz_str2Bool, toJson: zzz_bool2Str)
  bool? isWorking;

  @JsonKey(name: GIG_COUNT)
  String? gigCount;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: KUNM)
  String? kunm;

  @JsonKey(name: FONE)
  String? phone;

  @JsonKey(name: FONE_CODE)
  String? phoneCode;

  @JsonKey(name: EMAIL)
  String? email;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "middleName")
  String? middleName;

  @JsonKey(name: "lastName")
  String? lastName;

  @JsonKey(name: "dob", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? dob;

  @JsonKey(name: "ppuid")
  String? ppuid;

  @JsonKey(name: "parentName")
  String? parentName;

  @JsonKey(name: "parentEmail")
  String? parentEmail;

  @JsonKey(name: "parentPhone")
  String? parentPhone;

  /*
   * Address
   */

  @JsonKey(name: "addressLine")
  String? addressLine;

  @JsonKey(name: "addressLine1")
  String? addressLine1;

  @JsonKey(name: "addressLine2")
  String? addressLine2;

  @JsonKey(name: "city")
  String? city;

  @JsonKey(name: "stateCode")
  String? stateCode;

  @JsonKey(name: "zipCode")
  String? zipCode;

  @JsonKey(name: "ward")
  String? ward;

  @JsonKey(name: "district")
  String? district;

  @JsonKey(name: "countryCode")
  String? countryCode;

  @JsonKey(name: "displayImg")
  String? displayImg;

  @JsonKey(name: "avatar")
  String? avatarURL;

  @JsonKey(name: "vurl")
  String? videoURL;

  @JsonKey(name: "avatarData")
  String? avatarImageData;

  @JsonKey(name: "heroAvatar")
  String? heroAvatarURL;

  // Schoolbird 'user.dart' data
  @JsonKey(name: "gradeLevel")
  String? gradeLevel;

  @JsonKey(name: "schoolName")
  String? schoolName;

  @JsonKey(name: "businessName")
  String? businessName;

  @JsonKey(name: "userRating")
  String? userRating;

  @JsonKey(name: "userStatus")
  String? userStatus;

  @JsonKey(name: "userRatingCount")
  String? userRatingCount;

  @JsonKey(name: "bankID")
  String? bankID;

  @JsonKey(name: "bankName")
  String? bankName;

  @JsonKey(name: "bankAccName")
  String? bankAccName;

  @JsonKey(name: "bankAccNumber")
  String? bankAccNumber;

  @JsonKey(name: "educations")
  List<KEducation>? educations;

  @JsonKey(name: "addresses")
  List<KAddress>? addresses;

  @JsonKey(name: "notes")
  List<KNote>? notes;

  @JsonKey(name: "officialIDNumber")
  String? officialIDNumber;

  @JsonKey(name: "officialIDURL")
  String? officialIDURL;

  @JsonKey(name: "officialIDData")
  String? officialIDData;

  @JsonKey(name: "studentIDNumber")
  String? studentIDNumber;

  @JsonKey(name: "studentIDURL")
  String? studentIDURL;

  @JsonKey(name: "studentIDData")
  String? studentIDData;

  @JsonKey(name: "joinDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? joinDate;

  @JsonKey(name: "latLng")
  KLatLng? currentLatLng;

  @JsonKey(name: "linkStatus")
  String? linkStatus;

  @JsonKey(name: "distance", fromJson: zzz_atod, toJson: zzz_dtoa)
  double? distance;

  @JsonKey(name: CV_TEXT)
  String? cvText;

  /// Methods
  @JsonKey(ignore: true)
  String get sbContactName =>
      this.kunm == null ? (this.fullName ?? "") : "@${this.kunm}";

  @JsonKey(ignore: true)
  String? get sbFullName =>
      this.businessName ??
      KUtil.prettyName(fnm: firstName, mnm: middleName, lnm: lastName) ??
      this.phone;

  @JsonKey(ignore: true)
  String get contactName {
    if (kunm == null) {
      return fullName ?? "";
    }
    return "@$kunm - $fullName";
  }

  // TODO - fix reward user (non-regis phone only)
  String? get fullName =>
      KUtil.prettyName(fnm: firstName, mnm: middleName, lnm: lastName) ?? phone;

  String? get prettyDistrict {
    // Check if district not contains one of item in KUtil.ignoreAddressWords list then add Quận before it
    if (district != null && district!.isNotEmpty) {
      if (KUtil.ignoreAddressWords.any((word) => district!.contains(word))) {
        return district;
      } else {
        return "${KPhrases.district} $district";
      }
    }
    return district;
  }

  String? get prettyWard {
    // Check if district not contains one of item in KUtil.ignoreAddressWords list then add Quận before it
    if (ward != null && ward!.isNotEmpty) {
      if (KUtil.ignoreAddressWords.any((word) => ward!.contains(word))) {
        return ward;
      } else {
        return "${KPhrases.ward} $ward";
      }
    }
    return ward;
  }

  String get area {
    final address = [
      prettyWard,
      prettyDistrict,
      city,
    ].where((e) => e != null).join(", ");
    return address;
  }

  String get prettyAddress {
    if ((this.addresses?.length ?? 0) > 0) {
      return this.addresses!.first.prettyAddress;
    }
    final area = this.area;
    if (area.contains(this.addressLine1 ?? "")) {
      return area;
    } else {
      return "${this.addressLine1}, $area";
    }
  }

  String get prettyFone =>
      KUtil.prettyFone(foneCode: phoneCode ?? "", number: phone ?? "");

  String get firstInitial => firstName?.substring(0, 1) ?? "";

  // JSON
  KUser();

  factory KUser.fromJson(Map<String, dynamic> json) => _$KUserFromJson(json);

  Map<String, dynamic> toJson() => _$KUserToJson(this);
}
