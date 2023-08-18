import 'package:app_core/app_core.dart';
import 'package:app_core/model/keducation.dart';
import 'package:app_core/model/kaddress.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kgig_user.g.dart';

@JsonSerializable()
class KGigUser extends KUser {
  @JsonKey(name: "billDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? billDate;

  @JsonKey(name: "billGigs")
  String? billGigs;

  @JsonKey(name: "billDuration", fromJson: zzz_str2Dur, toJson: zzz_dur2Str)
  Duration? billDuration;

  @JsonKey(name: "billAmount")
  String? billAmount;

  @JsonKey(name: "billNote")
  String? billNote;

  @JsonKey(name: "billPayDate", fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? billPayDate;

  @JsonKey(name: "billPayAmount")
  String? billPayAmount;

  @JsonKey(name: "billPayNote")
  String? billPayNote;

  @JsonKey(name: "tierRate")
  String? tierRate;

  // JSON
  KGigUser();

  factory KGigUser.fromJson(Map<String, dynamic> json) => _$KGigUserFromJson(json);

  Map<String, dynamic> toJson() => _$KGigUserToJson(this);
}