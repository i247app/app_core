import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/app_core.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  static const String APP_GIG = "gig";
  static const String REVIEW_ID = "reviewID";
  static const String REF_APP = "refApp";
  static const String REF_ID = "refID";
  static const String REVIEWEE = "reviewee";
  static const String REVIEWER = "reviewer";
  static const String RATING = "rating";
  static const String REVIEW_TEXT = "reviewText";
  static const String REVIEW_DATE = "reviewDate";

  @JsonKey(name: REVIEW_ID)
  String? reviewID;

  @JsonKey(name: REF_APP)
  String? refApp;

  @JsonKey(name: REF_ID)
  String? refID;

  @JsonKey(name: REVIEWEE)
  String? reviewee;

  @JsonKey(name: REVIEWER)
  String? reviewer;

  @JsonKey(name: RATING)
  String? ratingValue;

  @JsonKey(name: REVIEW_TEXT)
  String? comment;

  @JsonKey(name: REVIEW_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? reviewDate;

  // JSON
  Review();

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
