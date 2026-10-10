// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KPost _$KPostFromJson(Map<String, dynamic> json) => KPost()
  ..postID = json['postID'] as String?
  ..postStatus = json['postStatus'] as String?
  ..price = json['price'] as String?
  ..title = json['title'] as String?
  ..subtitle = json['subtitle'] as String?
  ..text = json['text'] as String?
  ..postType = json['postType'] as String?
  ..contentType = json['contentType'] as String?
  ..mediaURL = json['mediaURL'] as String?
  ..mediaType = json['mediaType'] as String?
  ..reviews = (json['reviews'] as List<dynamic>?)
      ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
      .toList()
  ..users = (json['users'] as List<dynamic>?)
      ?.map((e) => KUser.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KPostToJson(KPost instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('postID', instance.postID);
  writeNotNull('postStatus', instance.postStatus);
  writeNotNull('price', instance.price);
  writeNotNull('title', instance.title);
  writeNotNull('subtitle', instance.subtitle);
  writeNotNull('text', instance.text);
  writeNotNull('postType', instance.postType);
  writeNotNull('contentType', instance.contentType);
  writeNotNull('mediaURL', instance.mediaURL);
  writeNotNull('mediaType', instance.mediaType);
  writeNotNull('reviews', instance.reviews?.map((e) => e.toJson()).toList());
  writeNotNull('users', instance.users?.map((e) => e.toJson()).toList());
  return val;
}
