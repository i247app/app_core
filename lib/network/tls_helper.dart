import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:app_core/network/kpacket_header.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/foundation.dart';

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
    "bird:tutor.list",
  ];

  static int _reqCount = 0;
  static Map<String, dynamic> _cachedDefaultReqData = {};

  static Future<Map<String, dynamic>> send(
    Map<String, dynamic> inputData, {
    KHostInfo? hostInfo,
    bool isAuthed = true,
    bool isDebug = true,
  }) async {
    final int reqID = _reqCount++;
    final String apiName = "${inputData['svc']}:${inputData['req']}";
    print(apiName);
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
      if (isDebug) {
        _log(
          reqID,
          "CLIENT [${hostInfo.nickname}]",
          apiName,
          json,
          ignoreBlacklist: true,
        );
      }
      // Write to socket and get the response
      socketResource = await KSocketManager.getSocket(hostInfo);
      final List<int> raw =
          await writeToSocket(socketResource, utf8.encode(json));
      answer = utf8.decode(raw, allowMalformed: false);

      // Test JSON for validity
      decodedAnswer = jsonDecode(answer);
    } on SocketException catch (e) {
      print(e.toString());

      // Kill the socket so it doesn't get recycled
      socketResource?.close();
      socketResource = null;

      answer = buildErrorJSON(
        kstatus: KSTATUS_SOCKET_ERROR,
        message: KPhrases.noWifi,
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
    if (isDebug) {
      _log(
        reqID,
        "SERVER [${hostInfo.nickname}]",
        apiName,
        answer,
        ignoreBlacklist: false,
      );
    }

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
      final condition =
          ((int.tryParse(result["kstatus"]) ?? 0) == KCoreCode.BAD_SESSION) &&
              KSessionData.hasActiveSession;
      if (condition) {
        KSessionData.wipeSession();
        // TODO: Check for schoolbird
        KToastHelper.show("Session terminated");
        KRebuildHelper.forceHardReload();
      }
    } catch (_) {}

    return result as Map<String, dynamic>;
  }

  static String buildErrorJSON({
    required int kstatus,
    required String message,
  }) {
    final data = SimpleResponse()
      ..kstatus = kstatus
      ..kmessage = message;
    return jsonEncode(data.toJson());
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
      "tz": () async => await KUtil.getTimezoneName(),
      "utcOffset": () async => await KUtil.getTimezonOffset(),
      "locale": () async => KUtil.localeName(),
      "language": () async => KUtil.localeName().split("_")[0],
      "domain": () async => await KUtil.getPackageName(),
      "countryCode": () async => await KSessionData.getCountryCode(),
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
      "pushToken": await KSessionData.getFCMToken(),
      "voipToken": await KSessionData.getVoipToken(),
      "tokenMode": KUtil.getPushTokenMode(),
    };

    if (KLocationHelper.cachedPosition != null) {
      data["latLng"] = KLatLng.fromPosition(KLocationHelper.cachedPosition!);
      data["countryCode"] = await KSessionData.getCountryCode();
    }

    return {...data, "metadata": data};
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
    final displayMessage = logBlacklist.contains(apiName) && !ignoreBlacklist
        ? compactLog(message)
        : KUtil.prettyJSON(message);
    debugPrint('[$reqID] $tag $apiName - $displayMessage');
  }

  static Future<List<int>> writeToSocket(
    KSocketResource socketResource,
    List<int> data,
  ) async {
    final List<int> body = zip(data);

    final sendHeader = KPacketHeader(bodyLength: body.length);
    final sendBytes = BytesBuilder();
    sendBytes.add(sendHeader.toBytes()); // Packet header
    sendBytes.add(body); // Body

    final responseBytes = <int>[];
    KPacketHeader? responseHeader;

    // Setup response read loop
    final Completer<Null> respCompleter = Completer<Null>();
    final streamSub = socketResource.stream.listen((List<int> bytes) {
      responseBytes.addAll(bytes);

      // Read in the header
      if (responseHeader == null)
        responseHeader = KPacketHeader.fromBytes(bytes.sublist(0, 16));

      // Only complete the completer once ALL bytes are read
      if (responseHeader?.bodyAndHeaderLength == responseBytes.length)
        respCompleter.complete();
    });

    // Write my message on the socket
    socketResource.socket.add(sendBytes.toBytes());

    final Uint8List rawResponse = await respCompleter.future
        .then((_) => Uint8List.fromList(responseBytes));
    streamSub.cancel();

    return unzip(rawResponse.sublist(16).toList());
  }
}
