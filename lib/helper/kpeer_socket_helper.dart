import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class KPeerSocketHelper {
  static IO.Socket? socket;
  static String? localPeerId = null;
  static String? roomId = null;

  static final StreamController<List<dynamic>> _dataStreamController =
      StreamController.broadcast();

  static Stream<List<dynamic>> get dataStream =>
      _dataStreamController.stream.asBroadcastStream();

  static Future dispose() async {
    try {
      socket?.dispose();
    } catch (ex) {}
    KPeerSocketHelper.socket = null;
  }

  static Future init(_roomId, _localPeerId) async {
    print('socket init');
    roomId = _roomId;
    localPeerId = _localPeerId;

    print('http://${KHostConfig.peerjsSocket.toString()}');
    final _socket = IO.io(
      'http://${KHostConfig.peerjsSocket.toString()}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNewConnection()
          .build(),
    );
    KPeerSocketHelper.socket = _socket;

    KPeerSocketHelper.socket!.onError((data) {
      print('socket error ${data}');
    });

    KPeerSocketHelper.socket!.onConnect((_) {
      print('connect');
      KPeerSocketHelper.socket!.emit('join-room', [roomId, localPeerId]);
    });

    KPeerSocketHelper.socket!.on('data', (data) {
      print("Adsasads");
      _dataStreamController.add(data);
    });
  }
}
