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
    ListXFRProxyResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('xfrProxies', instance.proxies?.map((e) => e.toJson()).toList());
  return val;
}
