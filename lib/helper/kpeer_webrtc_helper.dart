import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_core/model/kremote_peer.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sb_peerdart/sb_peerdart.dart';

import 'khost_config.dart';

enum KPeerWebRTCStatus { OPEN, CLOSE, CALL, CONNECTION, CONNECTED }

abstract class KPeerWebRTCHelper {
  static const RETRY_MAX = 5;
  static const PACKET_TYPE_METADATA = 'METADATA';
  static const PACKET_TYPE_RETRIEVE_METADATA = 'RETRIEVE_METADATA';
  static const CONTROL_SIGNAL_LEAVE = 'LEAVE';
  static const CONTROL_SIGNAL_END = 'END';

  static String? localPeerId = null;
  static String? localDisplayName = null;
  static Peer? peer = null;
  static MediaStream? mediaStream = null;
  static List<KRemotePeer> remotePeers = [];
  static bool isAutoCall = false;

  static final StreamController<KPeerWebRTCStatus>
  _connectionStatusStreamController = StreamController.broadcast();

  static Stream<KPeerWebRTCStatus> get connectionStatusStream =>
      _connectionStatusStreamController.stream.asBroadcastStream();

  static final StreamController<MediaStream> _localPlayerStreamController =
  StreamController.broadcast();

  static Stream<MediaStream> get localPlayerStream =>
      _localPlayerStreamController.stream.asBroadcastStream();

  static final StreamController<Map<String, dynamic>>
  _remotePlayerStreamStreamController = StreamController.broadcast();

  static Stream<Map<String, dynamic>> get remotePlayerStream =>
      _remotePlayerStreamStreamController.stream.asBroadcastStream();

  static final StreamController<Map<String, dynamic>> _dataStreamController =
  StreamController.broadcast();

  static Stream<Map<String, dynamic>> get dataStream =>
      _dataStreamController.stream.asBroadcastStream();

  static Future dispose() async {
    try {
      KPeerWebRTCHelper.mediaStream?.dispose();
      KPeerWebRTCHelper.remotePeers.forEach((remotePeer) {
        remotePeer.mediaConnection?.dispose();
        remotePeer.dataConnection?.dispose();
      });
      KPeerWebRTCHelper.peer?.dispose();
    } catch (ex) {}
    KPeerWebRTCHelper.peer = null;
    KPeerWebRTCHelper.mediaStream = null;
    KPeerWebRTCHelper.remotePeers = [];
    KPeerWebRTCHelper.localDisplayName = null;
    KPeerWebRTCHelper.localPeerId = null;
    KPeerWebRTCHelper.isAutoCall = false;
  }

  static Future init(MediaStream localStream, {
    String? localPeerID,
    bool? auto,
    String? displayName,
  }) async {
    KPeerWebRTCHelper.peer = null;
    KPeerWebRTCHelper.mediaStream = null;
    KPeerWebRTCHelper.remotePeers = [];
    KPeerWebRTCHelper.localDisplayName = displayName;
    KPeerWebRTCHelper.localPeerId = localPeerID;
    KPeerWebRTCHelper.mediaStream = localStream;
    KPeerWebRTCHelper.isAutoCall = auto ?? true;

    if (KPeerWebRTCHelper.mediaStream != null) {
      KPeerWebRTCHelper.mediaStream!.onRemoveTrack = (_) {
        print("asdasads");
      };
      KPeerWebRTCHelper.peer = Peer(
        id: KPeerWebRTCHelper.localPeerId,
        options: PeerOptions(
          debug: LogLevel.All,
          // secure: false,
          // host: KHostConfig.peerjs.hostname,
          // port: KHostConfig.peerjs.port,
          // path: '/sb-peer',
          config: {
            'iceServers': [
              {
                'urls': [
                  'stun:stun.l.google.com:19302',
                  'stun:stun1.l.google.com:19302',
                  'stun:stun2.l.google.com:19302',
                  'stun:stun3.l.google.com:19302',
                  'stun:stun4.l.google.com:19302',
                ]
              },
              {
                "urls": [
                  "turn:eu-0.turn.peerjs.com:3478",
                  "turn:us-0.turn.peerjs.com:3478",
                ],
                "username": "peerjs",
                "credential": "peerjsp",
              },
            ],
            'sdpSemantics': "unified-plan",
            // 'iceServers': [
            //   {
            //     'url': "stun:stun.l.google.com:19302",
            //   },
            // ],
          },
        ),
      );

      peer!.on<Exception>('error').listen((error) {
        print("PEER ERROR ${error}");
      });

      peer!.on('open').listen((id) {
        print("On [open] ${id}");
        _connectionStatusStreamController.add(KPeerWebRTCStatus.OPEN);
      });

      peer!.on('close').listen((id) {
        print("On [close] ${id}");
        _connectionStatusStreamController.add(KPeerWebRTCStatus.CLOSE);
      });

      peer!.on<MediaConnection>('call').listen((call) {
        print("On [call] - remote call... ${call}");
        _connectionStatusStreamController.add(KPeerWebRTCStatus.CALL);

        final remotePeer = getOrCreatePeer(call.peer);
        remotePeer.mediaConnection = call;
        final remotePeerIndex = getIndexOfRemotePeer(remotePeer);
        if (remotePeerIndex > -1)
          KPeerWebRTCHelper.remotePeers[remotePeerIndex].mediaConnection =
              remotePeer.mediaConnection;

        call.answer(KPeerWebRTCHelper.mediaStream!);
        handleRemoteStreamCall(call);
      });

      peer!.on<DataConnection>('connection').listen((conn) {
        print("On [connection] - remote data connection... ${conn}");
        _connectionStatusStreamController.add(KPeerWebRTCStatus.CONNECTION);

        final remotePeer = getOrCreatePeer(conn.peer);
        remotePeer.dataConnection = conn;
        final remotePeerIndex = getIndexOfRemotePeer(remotePeer);
        if (remotePeerIndex > -1)
          KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection =
              remotePeer.dataConnection;

        onPeerDiscovery(remotePeer);

        conn.on('data').listen((data) {
          _dataStreamController.add({
            'remotePeer': remotePeer,
            'data': data,
          });
        });
      });

      _localPlayerStreamController.add(localStream);
    }
  }

  static handleRemoteStreamCall(MediaConnection call) {
    print('handleRemoteStreamCall');
    call.on('error').listen((error) {
      print('Call error ${error}');
    });

    call.on<MediaStream>("stream").listen((remoteStream) {
      print(
          "Setting up remote video... ${remoteStream.id} ${new DateTime.now()
              .toIso8601String()}");
      _connectionStatusStreamController.add(KPeerWebRTCStatus.CONNECTED);

      final remotePeer = getOrCreatePeer(call.peer);
      _remotePlayerStreamStreamController.add({
        'peerID': remotePeer.peerID,
        'peer': remotePeer,
        'stream': remoteStream,
      });
    });
  }

  static onPeerDiscovery(KRemotePeer remotePeer) {
    final localPeerID = KPeerWebRTCHelper.localPeerId;
    final remotePeerID = remotePeer.peerID;
    final remotePeerIndex = getIndexOfRemotePeer(remotePeer);
    if (remotePeerIndex == -1) {
      return;
    }

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].status =
        KRemotePeer.STATUS_CONNECTED;

    final isActive = int.parse(remotePeer.peerID
        ?.split('-')
        .last ?? '0') <
        int.parse(localPeerID
            ?.split('-')
            .last ?? '0') &&
        localPeerID != remotePeerID;
    print("localPeerID ${isActive}");

    if (isActive) {
      KPeerWebRTCHelper.remotePeers[remotePeerIndex].role =
          KRemotePeer.ROLE_LISTENER;

      const options = {
        'constraints': {
          'mandatory': {
            // OfferToReceiveAudio: true,
            // OfferToReceiveVideo: false,
            'VoiceActivityDetection': true,
          },
          // offerToReceiveAudio: 1,
          // offerToReceiveVideo: 0,
        },
      };
      KPeerWebRTCHelper.remotePeers[remotePeerIndex].mediaConnection =
          peer!.call(remotePeerID!, KPeerWebRTCHelper.mediaStream!);
      handleRemoteStreamCall(
          KPeerWebRTCHelper.remotePeers[remotePeerIndex].mediaConnection!);
    } else {
      KPeerWebRTCHelper.remotePeers[remotePeerIndex].role =
          KRemotePeer.ROLE_CALLER;
    }
  }

  static int getIndexOfRemotePeer(KRemotePeer remotePeer) {
    return KPeerWebRTCHelper.remotePeers
        .indexWhere((_remotePeer) => remotePeer.peerID == _remotePeer.peerID);
  }

  // static void updateRemotePeer(KRemotePeer remotePeer) {
  //   final remotePeerIndex = KPeerWebRTCHelper.remotePeers
  //       .indexWhere((_remotePeer) => remotePeer.peerID == _remotePeer.peerID);
  //   if (remotePeerIndex > -1) {
  //     KPeerWebRTCHelper.remotePeers[remotePeerIndex] = remotePeer;
  //   } else {}
  // }

  static KRemotePeer getOrCreatePeer(String peerID) {
    final results = KPeerWebRTCHelper.remotePeers
        .where((remotePeer) => remotePeer.peerID == peerID);
    if (results.length > 0) {
      return results.first;
    } else {
      print(
          'new peerId ${peerID} ${KPeerWebRTCHelper.remotePeers.map((e) =>
          e.peerID)}');
      final remotePeer = KRemotePeer()
        ..peerID = peerID;
      KPeerWebRTCHelper.remotePeers.add(remotePeer);
      return remotePeer;
    }
  }

  static removePeer(String peerID) {
    final index = KPeerWebRTCHelper.remotePeers.indexWhere((remotePeer) => remotePeer.peerID == peerID);
    if (index > -1) {
      KPeerWebRTCHelper.remotePeers = KPeerWebRTCHelper.remotePeers.where((remotePeer) => remotePeer.peerID != peerID).toList();
    }
  }

  static Future<MediaStream> retrieveLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    final localStream =
    await navigator.mediaDevices.getUserMedia(mediaConstraints);

    return localStream;
  }

  static sendMultipleCalls(newRemotePeers) {
    newRemotePeers.forEach((remotePeer) {
      getOrCreatePeer(remotePeer);
    });

    // Start sending calls
    callAllPending();
  }

  static callAllPending() {
    final pendingPeers = KPeerWebRTCHelper.remotePeers
        .where((remotePeer) => remotePeer.status == KRemotePeer.STATUS_PENDING)
        .toList();

    pendingPeers.forEach((remotePeer) => sendCall(remotePeer));
  }

  static Future sendCall(KRemotePeer remotePeer) async {
    print('sendCall ${remotePeer.retryCount}');
    final remotePeerIndex = getIndexOfRemotePeer(remotePeer);
    if (remotePeerIndex == -1 ||
        remotePeer.peerID == null ||
        remotePeer.retryCount >= KPeerWebRTCHelper.RETRY_MAX) {
      return;
    }

    print("!!! WebRTC.sendCall ${remotePeer.peerID}");
    _connectionStatusStreamController.add(KPeerWebRTCStatus.CALL);

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection = peer!
        .connect(remotePeer.peerID!,
        options: PeerConnectOption(
            serialization: SerializationType.JSON,
            metadata: {
              'peerID': KPeerWebRTCHelper.localPeerId,
              'displayName': KPeerWebRTCHelper.localDisplayName,
            }));

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection!
        .on('error')
        .listen((error) {
      print("Data on [error] - connection error ${error}");
    });

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection!
        .on('open')
        .listen((event) {
      print("Data on [open] - Connection opened!");
      print("Calling ${remotePeer.peerID}...");

      onPeerDiscovery(remotePeer);
      KPeerWebRTCHelper.remotePeers[remotePeerIndex].retryCount = 0;
    });

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection!
        .on('data')
        .listen((data) =>
        _dataStreamController.add({
          'remotePeer': remotePeer,
          'data': data,
        }));

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection!
        .on('binary')
        .listen((data) {
          print('binary dâta');
      _dataStreamController.add({
        'remotePeer': remotePeer,
        'data': jsonDecode(utf8.decode(data)),
      });
    });

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].dataConnection!
        .on('close')
        .listen((event) {
      print("- - - A DATA CONNECTION CLOSED - - -");
      KPeerWebRTCHelper.remotePeers[remotePeerIndex] = KRemotePeer()
        ..peerID = KPeerWebRTCHelper.remotePeers[remotePeerIndex].peerID;
      _remotePlayerStreamStreamController.add({
        'peerID': KPeerWebRTCHelper.remotePeers[remotePeerIndex].peerID,
        'peer': KPeerWebRTCHelper.remotePeers[remotePeerIndex],
        'stream': null,
      });

      Future.delayed(Duration(milliseconds: 1000), () {
        sendCall(KPeerWebRTCHelper.remotePeers[remotePeerIndex]);
      });
    });

    KPeerWebRTCHelper.remotePeers[remotePeerIndex].retryCount++;
  }
}
