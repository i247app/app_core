// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_xfr_proxy_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListXFRProxyResponse _$ListXFRProxyResponseFromJson(
        Map<String, dynamic> json) =>
    ListXFRProxyResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..proxies = (json['xfrProxies'] as List<dynamic>?)
          ?.map((e) => XFRProxy.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ListXFRProxyResponseToJson(
        ListXFRProxyResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.proxies?.map((e) => e.toJson()).toList() case final value?)
        'xfrProxies': value,
    };
