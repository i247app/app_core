import 'dart:io';

import 'package:app_core/helper/host_config.dart';
import 'package:app_core/model/host_info.dart';

class SocketResource {
  static int count = 0;

  final int socketID = count++;
  final SecureSocket socket;
  final Stream<List<int>> stream;

  HostInfo get hostInfo => HostInfo.raw(
        this.socket.address.host,
        this.socket.remotePort,
      );

  SocketResource(this.socket, this.stream);

  Future close() => this.socket.close();

  factory SocketResource.fromSocket(SecureSocket socket) =>
      SocketResource(socket, socket.asBroadcastStream());
}

abstract class SocketManager {
  static Map<HostInfo, List<SocketResource>> _sockets = {};

  static Future<SocketResource> getSocket([HostInfo? hostInfo]) async {
    hostInfo ??= HostConfig.hostInfo;

    // Create map entry if needed
    if (!_sockets.containsKey(hostInfo)) _sockets[hostInfo] = [];

    // Check if sockets are empty
    if (_sockets[hostInfo] != null && _sockets[hostInfo]!.isEmpty) {
      // print("% % % % % SocketManager.getSocket CREATING NEW SOCKET");
      _sockets[hostInfo]!.add(await _createSocket(hostInfo));
    }
    return _sockets[hostInfo]!.removeLast();
  }

  static void releaseSocket(SocketResource socket) {
    socket.close();
    // _sockets[socket.hostInfo]!.add(socket);
  }

  static Future<SocketResource> _createSocket(HostInfo hostInfo) async {
    // print("creating socket for $hostInfo");
    return SecureSocket.connect(
      hostInfo.hostname,
      hostInfo.port,
      onBadCertificate: (_) => true,
    ).then((ss) => SocketResource.fromSocket(ss));
  }
}
