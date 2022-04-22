import 'package:app_core/app_core.dart';
import 'package:app_core/model/kaddress.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kobject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kuser.g.dart';

@JsonSerializable()
class KUser extends KObject {
  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "kunm")
  String? kunm;

  @JsonKey(name: "fone")
  String? phone;

  @JsonKey(name: "foneCode")
  String? phoneCode;

  @JsonKey(name: "fullAddressLine")
  String? fullAddress;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "firstName")
  String? firstName;

  @JsonKey(name: "middleName")
  String? middleName;

  @JsonKey(name: "lastName")
  String? lastName;

  @JsonKey(name: "dob", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? dob;

  @JsonKey(name: "parentName")
  String? parentName;

  @JsonKey(name: "parentEmail")
  String? parentEmail;

  @JsonKey(name: "parentPhone")
  String? parentPhone;

  /*
   * Address
   */
  @JsonKey(name: "addressLine1")
  String? address1;

  @JsonKey(name: "addressLine2")
  String? address2;

  @JsonKey(name: "city")
  String? city;

  @JsonKey(name: "stateCode")
  String? state;

  @deprecated
  @JsonKey(name: "zipCode")
  String? zip;

  @JsonKey(name: "countryCode")
  String? countryCode;

  @JsonKey(name: "displayImg")
  String? displayImg;

  @JsonKey(name: "avatar")
  String? avatarURL;

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
    if (kunm == null) return fullName ?? "";
    return "@$kunm $fullName";
  }

  // TODO - fix reward user (non-regis phone only)
  String? get fullName =>
      KUtil.prettyName(
          fnm: firstName ?? "", mnm: middleName ?? "", lnm: lastName ?? "") ??
      phone;

  String? get prettyAddress {
    final address = [
      address1,
      address2,
      city,
      state,
      zip,
    ].where((e) => e != null).join(", ");
    return address.isEmpty ? null : address;
  }

  String get prettyFone =>
      KUtil.prettyFone(foneCode: phoneCode ?? "", number: phone ?? "");

  String get firstInitial => firstName?.substring(0, 1) ?? "";

  // JSON
  KUser();

  factory KUser.fromJson(Map<String, dynamic> json) => _$KUserFromJson(json);

  Map<String, dynamic> toJson() => _$KUserToJson(this);
}
