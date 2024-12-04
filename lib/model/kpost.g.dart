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

Map<String, dynamic> _$KPostToJson(KPost instance) => <String, dynamic>{
      if (instance.postID case final value?) 'postID': value,
      if (instance.postStatus case final value?) 'postStatus': value,
      if (instance.price case final value?) 'price': value,
      if (instance.title case final value?) 'title': value,
      if (instance.subtitle case final value?) 'subtitle': value,
      if (instance.text case final value?) 'text': value,
      if (instance.postType case final value?) 'postType': value,
      if (instance.contentType case final value?) 'contentType': value,
      if (instance.mediaURL case final value?) 'mediaURL': value,
      if (instance.mediaType case final value?) 'mediaType': value,
      if (instance.reviews?.map((e) => e.toJson()).toList() case final value?)
        'reviews': value,
      if (instance.users?.map((e) => e.toJson()).toList() case final value?)
        'users': value,
    };
