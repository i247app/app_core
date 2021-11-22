// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review()
  ..reviewID = json['reviewID'] as String?
  ..refApp = json['refApp'] as String?
  ..refID = json['refID'] as String?
  ..reviewee = json['reviewee'] as String?
  ..reviewer = json['reviewer'] as String?
  ..ratingValue = json['rating'] as String?
  ..comment = json['reviewText'] as String?
  ..reviewDate = zzz_str2Date(json['reviewDate'] as String?);

Map<String, dynamic> _$ReviewToJson(Review instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reviewID', instance.reviewID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('refID', instance.refID);
  writeNotNull('reviewee', instance.reviewee);
  writeNotNull('reviewer', instance.reviewer);
  writeNotNull('rating', instance.ratingValue);
  writeNotNull('reviewText', instance.comment);
  writeNotNull('reviewDate', zzz_date2Str(instance.reviewDate));
  return val;
}
