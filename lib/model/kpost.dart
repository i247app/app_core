import 'package:app_core/app_core.dart';
import 'package:app_core/model/review.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kpost.g.dart';

@JsonSerializable()
class KPost {
  static const String POST_ID = "postID";
  static const String PRICE = "price";
  static const String SUBTITLE = "subtitle";
  static const String POST_TYPE = "postType";
  static const String CONTENT_TYPE = "contentType";
  static const String TITLE = "title";
  static const String TEXT = "text";
  static const String MEDIA_URL = "mediaURL"; // cover
  static const String MEDIA_TYPE = "mediaType"; // image | video
  static const String POST_STATUS = "postStatus"; // image | video
  static const String USERS = "users";
  static const String REVIEWS = "reviews";

  @JsonKey(name: POST_ID)
  String? postID;

  @JsonKey(name: POST_STATUS)
  String? postStatus;

  @JsonKey(name: PRICE)
  String? price;

  @JsonKey(name: TITLE)
  String? title;

  @JsonKey(name: SUBTITLE)
  String? subtitle;

  @JsonKey(name: TEXT)
  String? text;

  @JsonKey(name: POST_TYPE)
  String? postType;

  @JsonKey(name: CONTENT_TYPE)
  String? contentType;

  @JsonKey(name: MEDIA_URL)
  String? mediaURL;

  @JsonKey(name: MEDIA_TYPE)
  String? mediaType;

  @JsonKey(name: REVIEWS)
  List<Review>? reviews;

  @JsonKey(name: USERS)
  List<KUser>? users;

  // JSON
  KPost();

  factory KPost.fromJson(Map<String, dynamic> json) => _$KPostFromJson(json);

  Map<String, dynamic> toJson() => _$KPostToJson(this);
}
