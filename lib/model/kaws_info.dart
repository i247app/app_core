import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kaws_info.g.dart';

@JsonSerializable()
class KAWSInfo extends KObject {
  static const String ACCESS_KEY = "accessKey";
  static const String SECRET_KEY = "secretKey";
  static const String BUCKET_NAME = "bucketName";

  @JsonKey(name: ACCESS_KEY)
  String? accessKey;

  @JsonKey(name: SECRET_KEY)
  String? secretKey;

  @JsonKey(name: BUCKET_NAME)
  String? bucketName;

  // JSON
  KAWSInfo();

  factory KAWSInfo.fromJson(Map<String, dynamic> json) =>
      _$KAWSInfoFromJson(json);

  Map<String, dynamic> toJson() => _$KAWSInfoToJson(this);
}
