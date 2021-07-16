import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_core/helper/host_config.dart';
import 'package:app_core/helper/kcore_code.dart';
import 'package:app_core/helper/session_data.dart';
import 'package:app_core/helper/string_helper.dart';
import 'package:app_core/helper/toast_helper.dart';
import 'package:app_core/helper/util.dart';
import 'package:app_core/model/khost_info.dart';
import 'package:app_core/network/socket_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    KHostInfo? hostInfo,
    bool isAuthed = true,
  }) async {
    final int reqID = _reqCount++;
    final String apiName = "${inputData['svc']}:${inputData['req']}";

    hostInfo ??= KHostConfig.hostInfo;

    KSocketResource? socketResource;
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
      socketResource = await KSocketManager.getSocket(hostInfo);
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
        if (socketResource != null)
          KSocketManager.releaseSocket(socketResource);
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
    if (KStringHelper.isExist(result["ktoken"]) &&
        KSessionData.getSessionToken() != result["ktoken"] &&
        ((inputData['req'] == 'login' &&
                KStringHelper.isExist(KSessionData.getSessionToken())) ||
            (KStringHelper.isEmpty(KSessionData.getSessionToken())))) {
      KSessionData.setSessionToken(result["ktoken"]);
    }

    // Replace stack with Splash in case of BAD SESSION response
    try {
      if (result["kstatus"] == "${KCoreCode.BAD_SESSION}" &&
          KSessionData.hasActiveSession) {
        KSessionData.wipeSession();
        KToastHelper.show("Session terminated");
      }
    } catch (e) {}

    return result as Map<String, dynamic>;
  }

  static String buildErrorJSON({
    required int kstatus,
    required String message,
  }) {
    return "";
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
      "locale": () async => KUtil.localeName(),
      "domain": () async => await KUtil.getPackageName(),
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
      "ktoken": KSessionData.getSessionToken(),
      "tokenMode": KUtil.getPushTokenMode(),
    };

    return {...data, "metadata": data};
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
    if (!KHostConfig.isReleaseMode) {
      String displayMessage = logBlacklist.contains(apiName) && !ignoreBlacklist
          ? compactLog(message)
          : KUtil.prettyJSON(message);
      debugPrint('[$reqID] $tag $apiName - $displayMessage');
    }
  }

  static Future<List<int>> writeToSocket(
    KSocketResource socketResource,
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
