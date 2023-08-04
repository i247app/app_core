// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xfr_proxy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFRProxy _$XFRProxyFromJson(Map<String, dynamic> json) => XFRProxy()
  ..puid = json['puid'] as String?
  ..buid = json['buid'] as String?
  ..tokenName = json['tokenName'] as String?
  ..proxyStatus = json['proxyStatus'] as String?;

Map<String, dynamic> _$XFRProxyToJson(XFRProxy instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('puid', instance.puid);
  writeNotNull('buid', instance.buid);
  writeNotNull('tokenName', instance.tokenName);
  writeNotNull('proxyStatus', instance.proxyStatus);
  return val;
}
