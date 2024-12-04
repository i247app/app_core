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

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      if (instance.reviewID case final value?) 'reviewID': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.reviewee case final value?) 'reviewee': value,
      if (instance.reviewer case final value?) 'reviewer': value,
      if (instance.ratingValue case final value?) 'rating': value,
      if (instance.comment case final value?) 'reviewText': value,
      if (zzz_date2Str(instance.reviewDate) case final value?)
        'reviewDate': value,
    };
