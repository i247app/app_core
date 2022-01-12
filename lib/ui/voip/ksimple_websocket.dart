import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:async';

import 'package:app_core/app_core.dart';

typedef void OnMessageCallback(dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

class KSimpleWebSocket {
  final String url;

  WebSocket? _socket;

  OnOpenCallback? onOpen;
  OnMessageCallback? onMessage;
  OnCloseCallback? onClose;

  KSimpleWebSocket(this.url);

  Future<void> connect() async {
    // try {
    print("SimpleWebsocket.connect - ${this.url}");
    this._socket = await _createWebsocket(this.url);
    this.onOpen?.call();
    this._socket?.listen(
      (msg) {
        if (msg != "{}") print('websocket IN: ${jsonDecode(msg)}');
        this.onMessage?.call(msg);
      },
      onDone: () => this.onClose?.call(
            this._socket?.closeCode ?? 0,
            this._socket?.closeReason ?? "",
          ),
    );
    // } catch (e) {
    //   this.onClose?.call(500, e.toString());
    // }
  }

  void send(String data) {
    if (this._socket != null) {
      this._socket!.add(data);
      print('websocket OUT: $data');
    } else {
      print('websocket OUT - ERROR: socket is null');
    }
  }

  void close() {
    try {
      this._socket?.close();
    } catch (e) {
      print(e.toString());
    }

    try {
      this._socket = null;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<WebSocket> _createWebsocket(String url) async {
    Random r = KUtil.getRandom();
    String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));
    HttpClient client = HttpClient(context: SecurityContext());
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      print('KSimpleWebSocket: Allow self-signed certificate => $host:$port. ');
      return true;
    };

    HttpClientRequest request =
        await client.getUrl(Uri.parse(url)); // form the correct url here
    request.headers.add('Connection', 'Upgrade');
    request.headers.add('Upgrade', 'websocket');
    request.headers
        .add('Sec-WebSocket-Version', '13'); // insert the correct version here
    request.headers.add('Sec-WebSocket-Key', key.toLowerCase());

    HttpClientResponse response = await request.close();
    // ignore: close_sinks
    Socket socket = await response.detachSocket();
    var webSocket = WebSocket.fromUpgradedSocket(
      socket,
      protocol: 'signaling',
      serverSide: false,
    );

    return webSocket;
  }
}
