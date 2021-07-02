import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_core/helper/host_config.dart';
import 'package:app_core/helper/kcode.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/host_info.dart';
import 'package:app_core/model/response/base_response.dart';
import 'package:app_core/network/socket_manager.dart';
import 'package:flutter/material.dart';

// import 'package:app_core/helper/location_helper.dart';
// import 'package:app_core/helper/session_helper.dart';
// import 'package:app_core/helper/toast_helper.dart';
// import 'package:app_core/model/klat_lng.dart';

abstract class TLSHelper {
  static const int KSTATUS_UNKNOWN_ERROR = -1;
  static const int KSTATUS_SOCKET_ERROR = -2;
  static const int KSTATUS_JSON_ERROR = -3;
  static const int KSTATUS_BAD_HEADER_ERROR = -4;

  static const List<String> logBlacklist = [
    "amp:get.menu",
    "chat:chat.message.list",
    "bird:tutor.gig.active.list",
    "bird:tutor.gig.list",
  ];

  static int _reqCount = 0;
  static Map<String, dynamic> _cachedDefaultReqData = {};

  static Future<Map<String, dynamic>> send(
    Map<String, dynamic> inputData, {
    HostInfo? hostInfo,
    bool isAuthed = true,
  }) async {
    final int reqID = _reqCount++;
    final String apiName = "${inputData['svc']}:${inputData['req']}";

    hostInfo ??= HostConfig.hostInfo;

    SocketResource? socketResource;
    Map? decodedAnswer;
    String? answer;
    try {
      final Map<String, dynamic> defaultData =
          await getDefaultRequestData(reqID);
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.addAll(defaultData);
      data.addAll(inputData);

      // Remove all entries with null value
      data.removeWhere((_, v) => v == null);
      final String json = jsonEncode(data);

      // Write to socket and get the response
      socketResource = await SocketManager.getSocket(hostInfo);
      final List<int> raw =
          await writeToSocket(socketResource, utf8.encode(json));
      answer = utf8.decode(raw);

      _log(
        reqID,
        "CLIENT [${hostInfo.nickname}]",
        apiName,
        json,
        ignoreBlacklist: true,
      );

      // Test JSON for validity
      decodedAnswer = jsonDecode(answer);
    } on SocketException catch (e) {
      print(e.toString());

      // Kill the socket so it doesn't get recycled
      socketResource?.close();
      socketResource = null;

      answer = buildErrorJSON(
        kstatus: KSTATUS_SOCKET_ERROR,
        message: "Socket connection error",
      );
    } on RangeError catch (e) {
      print(e.toString());
      answer = buildErrorJSON(
        kstatus: KSTATUS_BAD_HEADER_ERROR,
        message: "Bad header",
      );
    } on FormatException catch (e) {
      print(e.toString());
      answer = buildErrorJSON(
        kstatus: KSTATUS_JSON_ERROR,
        message: "Invalid JSON",
      );
    } finally {
      // Try to close the socket no matter what
      try {
        if (socketResource != null) SocketManager.releaseSocket(socketResource);
      } catch (e) {}
    }

    _log(
      reqID,
      "SERVER [${hostInfo.nickname}]",
      apiName,
      answer,
      ignoreBlacklist: false,
    );

    // Store response token if local one is different
    final result = decodedAnswer ?? jsonDecode(answer);
    if (StringHelper.isExist(result["ktoken"]) &&
        SessionData.getSessionToken() != result["ktoken"] &&
        ((inputData['req'] == 'login' &&
                StringHelper.isExist(SessionData.getSessionToken())) ||
            (StringHelper.isEmpty(SessionData.getSessionToken())))) {
      SessionData.setSessionToken(result["ktoken"]);
    }

    // Replace stack with Splash in case of BAD SESSION response
    try {
      if (result["kstatus"] == "${KCode.BAD_SESSION}" &&
          SessionData.hasActiveSession) {
        // SessionData.wipeSession();
        // SessionHelper.hardReload();
        // ToastHelper.show("Session terminated");
      }
    } catch (e) {}

    return result as Map<String, dynamic>;
  }

  static String buildErrorJSON({
    required int kstatus,
    required String message,
  }) {
    return jsonEncode({
      BaseResponse.KSTATUS: kstatus,
      BaseResponse.KMSG: message,
    });
  }

  static List<int> zip(bytes) {
    final gzip = GZipCodec();
    final encoded = gzip.encode(bytes);
    return encoded;
  }

  static List<int> unzip(zipped) {
    final gzip = GZipCodec();
    final decoded = gzip.decode(zipped);
    return decoded;
  }

  static Future<Map<String, dynamic>> getDefaultRequestData(int reqID) async {
    final staticDataBuilders = {
      "versionName": () async => await Util.getBuildVersion(),
      "versionCode": () async => await Util.getBuildNumber(),
      "version": () async => await Util.getBuildVersion(),
      "build": () async => await Util.getBuildNumber(),
      "platform": () async => Util.getPlatformCode(),
      "svrVersion": () async => "x.x.x",
      "manufacturer": () async => await Util.getDeviceBrand(),
      "model": () async => await Util.getDeviceModel(),
      "deviceName": () async => await Util.getDeviceName(),
      "deviceNumber": () async => await Util.getDeviceID(),
      "locale": () async => Util.localeName(),
      "domain": () async => await Util.getPackageName(),
    };

    // Build the _cachedDefaultReqData
    if (_cachedDefaultReqData.isEmpty) {
      for (MapEntry<String, Future<Object?> Function()> entry
          in staticDataBuilders.entries) {
        if (!_cachedDefaultReqData.containsKey(entry.key))
          _cachedDefaultReqData[entry.key] = await entry.value();
      }
    }

    final data = {
      ..._cachedDefaultReqData,
      "reqID": "$reqID",
      "ktoken": SessionData.getSessionToken(),
      "pushToken": "",
      //await SessionData.getFCMToken(),
      "voipToken": "",
      //await SessionData.getVoipToken(),
      "tokenMode": "",
      //Util.getPushTokenMode(),
      "latLng": "",
      //(LocationHelper.cachedPosition == null ? null : KLatLng.fromPosition(LocationHelper.cachedPosition!)),
    };

    return data;
  }

  static List<int> getHeaderLengthBytes(int value) {
    final header = [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      (value) & 0xFF
    ];
    return header;
  }

  static String compactLog(String message) {
    final data = jsonDecode(message);
    String? kstatus = data["kstatus"];
    String? kmessage = data["kmessage"];

    return "#COMPACT " +
        ({
          "kstatus": kstatus ?? "",
          "kmessage": kmessage,
        }..removeWhere((_, v) => v == null))
            .toString();
  }

  static void _log(int reqID, String tag, String apiName, String message,
      {bool ignoreBlacklist = false}) {
    if (!HostConfig.isReleaseMode) {
      String displayMessage = logBlacklist.contains(apiName) && !ignoreBlacklist
          ? compactLog(message)
          : Util.prettyJSON(message);
      debugPrint('[$reqID] $tag $apiName - $displayMessage');
    }
  }

  static Future<List<int>> writeToSocket(
    SocketResource socketResource,
    List<int> data,
  ) async {
    final List<int> body = zip(data);

    final bb = BytesBuilder();
    bb.add([0xC1, 0xA0]); // Magic number
    bb.add(getHeaderLengthBytes(body.length)); // Header
    bb.add([0, 0, 0, 1]); // Keep Alive
    bb.add([0, 0, 0, 0, 0, 0]); // Reserved bytes
    bb.add(body); // Body

    final Completer<List<int>> completer = Completer<List<int>>();
    final streamSub = socketResource.stream.listen((bytes) {
      completer.complete(bytes);
    });

    final Uint8List rawBytes = bb.toBytes();
    socketResource.socket.add(rawBytes);

    final Uint8List rawResponse = Uint8List.fromList(await completer.future);
    streamSub.cancel();

    return unzip(rawResponse.sublist(16).toList());
  }
}
