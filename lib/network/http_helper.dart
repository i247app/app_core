import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:app_core/app_core.dart';

abstract class HTTPHelper {
  static Map<String, dynamic> _cachedDefaultReqData = {};

  static Future<http.Response> send(
    String path,
    Map<String, dynamic> inputData, {
    KHostInfo? hostInfo,
        String? hostScheme,
    bool isAuthed = true,
    bool isDebug = true,
  }) async {
    hostInfo ??= KHostConfig.hostInfo;
    hostScheme ??= 'http';

    final Map<String, dynamic> data = Map<String, dynamic>();
    data.addAll(inputData);
    data.addAll(await getDefaultRequestData(0));

    return await http.post(
      Uri(
        scheme: hostScheme,
        host: hostInfo.hostname,
        port: hostInfo.port,
        path: path,
      ),
      body: data,
    );
  }

  static Future<Map<String, dynamic>> getDefaultRequestData(int reqID) async {
    final staticDataBuilders = {
      "versionName": () async => await KUtil.getBuildVersion(),
      "versionCode": () async => await KUtil.getBuildNumber(),
      "version": () async => await KUtil.getBuildVersion(),
      "build": () async => await KUtil.getBuildNumber(),
      "platform": () async => KUtil.getPlatformCode(),
      "svrVersion": () async => "x.x.x",
      "manufacturer": () async => await KUtil.getDeviceBrand(),
      "model": () async => await KUtil.getDeviceModel(),
      "deviceName": () async => await KUtil.getDeviceName(),
      "deviceNumber": () async => await KUtil.getDeviceID(),
      "tz": () async => await KUtil.getTimezoneName(),
      "utcOffset": () async => await KUtil.getTimezoneOffset(),
      "locale": () async => KUtil.localeName(),
      "language": () async => KUtil.localeName().split("_")[0],
      "domain": () async => await KUtil.getPackageName(),
      "countryCode": () async => await KSessionData.getCountryCode(),
    };

    // Build the _cachedDefaultReqData
    if (_cachedDefaultReqData.isEmpty) {
      for (MapEntry<String, Future<Object?> Function()> entry
      in staticDataBuilders.entries) {
        if (!_cachedDefaultReqData.containsKey(entry.key)) {
          _cachedDefaultReqData[entry.key] = await entry.value();
        }
      }
    }

    final data = {
      ..._cachedDefaultReqData,
      "reqID": "$reqID",
      "ktoken": KSessionData.getSessionToken(),
      "pushToken": await KSessionData.getFCMToken(),
      "voipToken": await KSessionData.getVoipToken(),
      "tokenMode": KUtil.getPushTokenMode(),
    };

    // if (KLocationHelper.cachedPosition != null) {
    //   data["latLng"] = KLatLng.fromPosition(KLocationHelper.cachedPosition!);
    //   data["countryCode"] = await KSessionData.getCountryCode();
    // }

    return {...data};
  }
}
