import 'dart:io';

import 'package:app_core/helper/host_config.dart';
import 'package:app_core/model/khost_info.dart';

class KSocketResource {
  static int _count = 0;

  final int socketID = _count++;
  final SecureSocket socket;
  final Stream<List<int>> stream;

  KHostInfo get hostInfo => KHostInfo.raw(
        this.socket.address.host,
        this.socket.remotePort,
      );

  KSocketResource(this.socket, this.stream);

  Future close() => this.socket.close();

  factory KSocketResource.fromSocket(SecureSocket socket) =>
      KSocketResource(socket, socket.asBroadcastStream());
}

abstract class KSocketManager {
  static Map<KHostInfo, List<KSocketResource>> _sockets = {};

  static Future<KSocketResource> getSocket([KHostInfo? hostInfo]) async {
    hostInfo ??= KHostConfig.hostInfo;

    // Create map entry if needed
    if (!_sockets.containsKey(hostInfo)) _sockets[hostInfo] = [];

    // Check if sockets are empty
    if (_sockets[hostInfo] != null && _sockets[hostInfo]!.isEmpty) {
      // print("% % % % % SocketManager.getSocket CREATING NEW SOCKET");
      _sockets[hostInfo]!.add(await _createSocket(hostInfo));
    }
    return _sockets[hostInfo]!.removeLast();
  }

  static void releaseSocket(KSocketResource socket) {
    socket.close();
    // _sockets[socket.hostInfo]!.add(socket);
  }

  static Future<KSocketResource> _createSocket(KHostInfo hostInfo) async {
    // print("creating socket for $hostInfo");
    return SecureSocket.connect(
      hostInfo.hostname,
      hostInfo.port,
      onBadCertificate: (_) => true,
    ).then((ss) => KSocketResource.fromSocket(ss));
  }
}
