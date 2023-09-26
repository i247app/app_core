import 'package:app_core/app_core.dart';
import 'package:app_core/model/kobject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kfoo.g.dart';

@JsonSerializable()
class KFoo extends KObject {
  static const String FOO = "foo";
  static const String BAR = "bar";
  static const String DATA = "data";
  static const String DATAS = "datas";
  static const String FOO_STATUS = "fooStatus";

  @JsonKey(name: FOO)
  String? foo;

  @JsonKey(name: BAR)
  String? bar;

  @JsonKey(name: DATA)
  String? data;

  @JsonKey(name: DATAS, toJson: zzz_list2Str, fromJson: zzz_str2List)
  List<String>? datas;

  @JsonKey(name: FOO_STATUS)
  String? fooStatus;

  // JSON
  KFoo();

  factory KFoo.fromJson(Map<String, dynamic> json) => _$KFooFromJson(json);

  Map<String, dynamic> toJson() => _$KFooToJson(this);
}
