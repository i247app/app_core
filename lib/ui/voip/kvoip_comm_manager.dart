import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:app_core/helper/kwebrtc_helper.dart';
import 'package:app_core/ui/voip/ksimple_websocket.dart';
import 'package:app_core/ui/voip/kvoip_context.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:app_core/app_core.dart';

enum P2PPeerType { not_connected, spectating, joined }

enum SignalingState {
  CallStateNew,
  CallStateRoomCreated,
  CallStateRoomInfo,
  CallStateRoomNewParticipant,
  CallStateRoomEmpty,
  // CallStateRinging,
  CallStateInvite,
  // CallStateConnected,
  CallStateAccepted,
  CallStateBye,
  CallStateRejected,
  ConnectionOpen,
  ConnectionClosed,
  // ConnectionError,
}

/*
 * callbacks for Signaling API.
 */
typedef void SignalingStateCallback(SignalingState state);
typedef void StreamStateCallback(String id, MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void DataChannelMessageCallback(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RTCDataChannel dc);
typedef void InfoMessage(String msg, int code);
typedef void ErrorMessage(String msg, int code);
typedef void CameraToggled(bool isEnabled);
typedef void MicToggled(bool isEnabled);

class KVOIPCommManager {
  static const int CODE_MISSING = -1;
  static const int CODE_INCOMING_CALL = 1;
  static const int CODE_2 = 2;
  static const int CODE_3 = 3;
  static const int CODE_4 = 4;
  static const int CODE_5 = 5;
  static const int CODE_6 = 6;
  static const int NO_PEER = 7;

  static const Map<String, dynamic> CONSTRAINTS = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  static const Map<String, dynamic> CONSTRAINTS_NO_VIDEO = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  static const Map<String, dynamic> PEER_CONN_CONFIG = {
    'mandatory': {},
    // 'sdpSemantics': 'uinified-plan',
    'sdpSemantics': 'unified-plan',
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  static int _wsCallID = 0;

  final String puid;
  final String deviceID;
  final String nickname;

  bool isDisposed = false;

  String get myClientID => KWebRTCHelper.buildWebRTCClientID(
        puid: this.puid,
        deviceID: this.deviceID,
      );

  final KHostInfo hostInfo = KSessionData.webRTCHostInfo;
  final Set<String> connectedPeerIDs = {};
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, RTCDataChannel> _dataChannels = {};
  final Map<String, List<RTCIceCandidate>> _remoteCandidates = {};
  final List<MediaStream> _localStreams = [];
  final List<MediaStream> _remoteStreams = [];

  KVoipContext? voipContext;
  KSimpleWebSocket? _socket;
  Map<String, dynamic>? _turnCredential;
  KP2PSession? session;

  /// call offer getting data saving for reusing purpose
  String? _offerID;
  String? _offerMedia;

  SignalingStateCallback? onStateChange;
  StreamStateCallback? onLocalStream;
  StreamStateCallback? onAddRemoteStream;
  StreamStateCallback? onRemoveRemoteStream;
  OtherEventCallback? onPeersUpdate;
  DataChannelMessageCallback? onDataChannelMessage;
  DataChannelCallback? onNewDataChannel;
  InfoMessage? onCallInfo;
  ErrorMessage? onCallError;
  CameraToggled? onCameraToggled;
  MicToggled? onMicToggled;

  P2PPeerType peerType = P2PPeerType.not_connected;
  Map<String, dynamic> iceServers = {
    "iceServers": [
      {
        "urls": ["stun:138.197.180.29:3478"]
      },
      {
        "username": "bala",
        "credential": "bala",
        "urls": ["turn:138.197.180.29:3478"]
      },
    ]
  };

  Map<String, String> get stdConnInfo => {
        "myPUID": this.puid,
        "myClientID": this.myClientID,
        "id": this.myClientID, // TODO deprecated / legacy
      };

  MediaStream? get _localStream =>
      this._localStreams.isEmpty ? null : this._localStreams.first;

  String get host => this.hostInfo.hostname;

  int get port => this.hostInfo.port;

  KVOIPCommManager({
    required this.puid,
    required this.deviceID,
    this.nickname = "Anonymous",
    this.voipContext,
  });

  void close() {
    this.isDisposed = true;
    this._localStreams.forEach((st) => st.dispose());
    this._remoteStreams.forEach((st) => st.dispose());
    this._peerConnections.forEach((_, pc) => pc.close());
    this._dataChannels.forEach((_, dc) => dc.close());

    if (this._socket != null) KWebRTCHelper.releaseWebsocket(this._socket!);
    if (this.session?.id != null) sayGoodbye(tag: "KVOIPCommManager.close");
  }

  void switchCamera() {
    if (this._localStream != null)
      Helper.switchCamera(this._localStream!.getVideoTracks()[0]);
  }

  void setMicEnabled(bool isEnabled) {
    if (this._localStream != null) {
      this._localStream!.getAudioTracks()[0].enabled = isEnabled;
      _wsSend("toggle_mic_enabled", {
        ...this.stdConnInfo,
        "roomID": this.session?.id,
        "isEnabled": isEnabled,
      });
      voipContext?.withFlags((flags) => flags.isMySoundEnabled = isEnabled);
    }
  }

  void setCameraEnabled(bool isEnabled) {
    if (this._localStream != null) {
      this._localStream!.getVideoTracks()[0].enabled = isEnabled;
      _wsSend("toggle_camera_enabled", {
        ...this.stdConnInfo,
        "roomID": this.session?.id,
        "isEnabled": isEnabled,
      });
      voipContext?.withFlags((flags) => flags.isMyCameraEnabled = isEnabled);
    }
  }

  void setSpeakerphoneEnabled(bool isEnabled) {
    this._localStream?.getAudioTracks()[0].enableSpeakerphone(isEnabled);
    voipContext?.withFlags((flags) => flags.isMySpeakerEnabled = isEnabled);
  }

  void onPauseState() => setCameraEnabled(false);

  void onResumedState() {
    setMicEnabled(true);
    setCameraEnabled(true);
  }

  // void invite(String media, bool isUserScreen) {
  //   print("p2p_comm_manager.invite");
  //   this.connectedPeerIDs.forEach((String peerID) {
  //     this._sessionID = "${this._selfPUID}_$peerID";
  //     this._offerID = peerID;
  //     this.onStateChange?.call(SignalingState.CallStateNew);
  //
  //     _createPeerConnection(peerID, media: media, isUserScreen: isUserScreen)
  //         .then((pc) => _createOffer(peerID, pc, media));
  //   });
  // }

  void sayGoodbye({String? roomID, required String tag}) {
    print("[$tag] sayGoodbye fired...");

    // throw Exception();

    _wsSend('goodbye', {
      ...this.stdConnInfo,
      'roomID': this.session?.id ?? roomID,
    });
  }

  void onMessage(Map<String, dynamic> message) async {
    final data = message.containsKey("data") ? message['data'] : null;

    switch (message['type']) {
      case 'introduction':
        {
          this.onStateChange?.call(SignalingState.CallStateNew);
        }
        break;
      case 'room.create':
        {
          this.session = KP2PSession.fromJson(message["session"]);
          this.peerType = P2PPeerType.joined;
          print("CREATED ROOM ID - ${this.session?.id}");
          this.onStateChange?.call(SignalingState.CallStateRoomCreated);
        }
        break;
      case 'room.join':
        {
          this.session = KP2PSession.fromJson(message["session"]);
          this.peerType = P2PPeerType.joined;
        }
        break;
      case 'room.info':
        {
          this.session = KP2PSession.fromJson(message["session"]);
          this.peerType = P2PPeerType.spectating;
          this.onStateChange?.call(SignalingState.CallStateRoomInfo);
        }
        break;
      case 'room.new_participant':
        {
          final peerID = message['newPeerID'];
          final media = 'video';
          final isUserScreen = false;

          if (this.peerType == P2PPeerType.joined) {
            _createPeerConnection(
              peerID,
              media: media,
              isUserScreen: isUserScreen,
            )
                .then(
                    (pc) => pc == null ? null : _createOffer(peerID, pc, media))
                .whenComplete(() => this
                    .onStateChange
                    ?.call(SignalingState.CallStateRoomNewParticipant));
          } else {
            this
                .onStateChange
                ?.call(SignalingState.CallStateRoomNewParticipant);
          }
        }
        break;
      case 'room.is_empty':
        {
          this.onStateChange?.call(SignalingState.CallStateRoomEmpty);
        }
        break;
      case 'peers':
        {
          print("p2p_comm_manager.onMessage [peers]");
          final List<dynamic> peers = data;
          if (this.onPeersUpdate != null) {
            Map<String, dynamic> event = {
              'self': this.puid,
              'peers': peers,
            };
            this.onPeersUpdate?.call(event);
          }
        }
        break;
      case 'offer':
        {
          print("p2p_comm_manager.onMessage [offer] getting a -------- call");
          this._offerID = data["myClientID"];
          this._offerMedia = data['media'];

          // this.onStateChange?.call(SignalingState.CallStateNew);

          final RTCPeerConnection? pc = await _createPeerConnection(
            this._offerID ?? "",
            media: this._offerMedia ?? "",
            isUserScreen: false,
          );
          if (pc == null) break;

          final description = data['description'];
          await pc.setRemoteDescription(RTCSessionDescription(
            description['sdp'],
            description['type'],
          ));

          final List<RTCIceCandidate> candidates =
              this._remoteCandidates[this._offerID] ?? [];
          if (candidates.isNotEmpty) {
            candidates.forEach((can) async => await pc.addCandidate(can));
            candidates.clear();
          }

          _answerTheCall(pc);
        }
        break;
      case 'answer':
        {
          print("p2p_comm_manager.onMessage [answer] calll ---- accepteddddd");
          final String id = data['from'];
          final Map<String, dynamic> description = data['description'];

          final RTCPeerConnection? pc = this._peerConnections[id];
          if (pc != null) {
            await pc.setRemoteDescription(RTCSessionDescription(
              description['sdp'],
              description['type'],
            ));
          }
          this.onStateChange?.call(SignalingState.CallStateAccepted);
        }
        break;
      case 'candidate':
        {
          print("p2p_comm_manager.onMessage [candidate]");
          final peerID = data['from'];
          final candidateMap = data['candidate'];
          final pc = this._peerConnections[peerID];
          final RTCIceCandidate candidate = RTCIceCandidate(
            candidateMap['candidate'],
            candidateMap['sdpMid'],
            candidateMap['sdpMLineIndex'],
          );

          // !! OLD
          // if (pc != null) {
          //   await pc.addCandidate(candidate);
          // } else {
          //   this._remoteCandidates.add(candidate);
          // }

          // !! NEW
          if (pc != null) await pc.addCandidate(candidate);

          this._remoteCandidates[peerID] ??= [];
          this._remoteCandidates[peerID]?.add(candidate);
        }
        break;
      case 'leave':
        {
          print("p2p_comm_manager.onMessage [answer] hitting from --- leave");

          if (this._localStream != null) {
            this._localStream!.dispose();
            this._localStreams.clear();
          }

          this.onStateChange?.call(SignalingState.CallStateBye);
          // close();
        }
        break;
      case 'bye':
        {
          print("koip_comm_manager.onMessage case bye...");

          try {
            this.onStateChange?.call(SignalingState.CallStateBye);
          } catch (e) {
            print(e);
          }

          final to = data['to'];

          try {
            if (this._localStream != null) {
              this._localStream!.dispose();
              this._localStreams.clear();
            }
          } catch (e) {
            print(e);
          }

          try {
            final pc = this._peerConnections[to];
            if (pc != null) {
              pc.close();
              this._peerConnections.remove(to);
            }
          } catch (e) {
            print(e);
          }

          try {
            final dc = this._dataChannels[to];
            if (dc != null) {
              dc.close();
              this._dataChannels.remove(to);
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      case 'keepalive':
        {
          print('keepalive response!');
        }
        break;
      case 'receiver_connected':
        {
          // this.onStateChange?.call(SignalingState.CallStateInvite);
          this.connectedPeerIDs.add(data['from']);
        }
        break;
      case 'receiver_accept':
        {
          final myID = data['from'];

          final List<String> callerIDsToRemove = [];
          this.connectedPeerIDs.forEach((element) {
            if (element != myID) {
              sendByeDevice(element);
              callerIDsToRemove.add(element);
            }
          });
          this
              .connectedPeerIDs
              .removeWhere((e) => callerIDsToRemove.contains(e));

          this.onStateChange?.call(SignalingState.CallStateInvite);
        }
        break;
      case 'bye_device':
        {
          final String to = data['to'];

          if (this._localStream != null) {
            this._localStream!.dispose();
            this._localStreams.clear();
          }

          final pc = this._peerConnections[to];
          if (pc != null) {
            pc.close();
            this._peerConnections.remove(to);
          }

          final dc = this._dataChannels[to];
          if (dc != null) {
            dc.close();
            this._dataChannels.remove(to);
          }

          this.onStateChange?.call(SignalingState.CallStateBye);
          // close();
        }
        break;
      case 'status_update':
        {
          final String msg = data['msg_text'];
          final int code = data['code'] ?? CODE_MISSING;
          this.onCallInfo?.call(msg, code);
        }
        break;
      case 'error':
        {
          final String msg = data['reason'];
          final int code = data['code'] ?? CODE_MISSING;
          this.onCallError?.call(msg, code);
        }
        break;
      case 'toggle_camera_enabled':
        {
          final bool isEnabled = data['isEnabled'];
          // this.onCameraToggled?.call(isEnabled);
          onCameraToggledWrapper(isEnabled);
        }
        break;
      case 'toggle_mic_enabled':
        {
          final bool isEnabled = data['isEnabled'];
          // this.onMicToggled?.call(isEnabled);
          onMicToggledWrapper(isEnabled);
        }
        break;
      case 'call_rejected':
        {
          final to = data['to'];

          if (this._localStream != null) {
            this._localStream!.dispose();
            this._localStreams.clear();
          }

          final pc = this._peerConnections[to];
          if (pc != null) {
            pc.close();
            this._peerConnections.remove(to);
          }

          final dc = this._dataChannels[to];
          if (dc != null) {
            dc.close();
            this._dataChannels.remove(to);
          }

          this.onStateChange?.call(SignalingState.CallStateRejected);
        }
        break;
      default:
        break;
    }
  }

  Future connect([String? roomID]) async {
    this._socket = await KWebRTCHelper.getWebsocket(
      onOpen: () {
        final platform = Platform.isAndroid ? 'send_ANDROID' : 'send_IOS';
        _wsSend('introduction', {
          ...this.stdConnInfo,
          'name': this.nickname,
          'user_agent': platform,
          'roomID': roomID,
        });
      },
      onMessage: onMessage,
      onClose: (_, __) {},
    );

    final socket = this._socket!;
    await socket.connect();

    if (this._turnCredential == null) {
      try {
        this._turnCredential = await _getTurnCredential(this.host, this.port);
        if (this._turnCredential != null)
          this.iceServers = {
            'iceServers': [
              {
                'url': this._turnCredential!['uris'][0],
                'username': this._turnCredential!['username'],
                'credential': this._turnCredential!['password'],
              },
            ]
          };
      } catch (e) {}
    }

    /// my puid its for registering this user to our server
    this.onStateChange?.call(SignalingState.ConnectionOpen);
  }

  Future<MediaStream> _createVideoStream(
    String id,
    String media,
    bool isUserScreen,
  ) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    final MediaStream stream = isUserScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    onLocalStreamWrapper(id, stream);
    return stream;
  }

  Future<MediaStream> _createAudioStream(
    String id,
    String media,
    bool isUserScreen,
  ) async {
    final Map<String, dynamic> mediaConstraints = {'audio': true};
    final MediaStream stream = isUserScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    onLocalStreamWrapper(id, stream);

    return stream;
  }

  void onLocalStreamWrapper(String id, MediaStream stream) {
    onLocalStream?.call(id, stream);
    voipContext?.withLocalRenderer((localRenderer) {
      localRenderer?.srcObject = stream;
    });
  }

  void onCameraToggledWrapper(bool b) {
    onCameraToggled?.call(b);
    voipContext?.withFlags((flags) => flags.isMyCameraEnabled = b);
  }

  void onMicToggledWrapper(bool b) {
    onMicToggled?.call(b);
    voipContext?.withFlags((flags) => flags.isMySoundEnabled = b);
  }

  Future<RTCPeerConnection?> _createPeerConnection(
    String peerID, {
    String media = 'video',
    bool isUserScreen = true,
  }) async {
    if (this._peerConnections[peerID] != null) return null;

    print("p2p_comm_manager._createPeerConnection for peerID == $peerID");
    final RTCPeerConnection pc = await createPeerConnection(
      this.iceServers,
      PEER_CONN_CONFIG,
    );
    this._peerConnections[peerID] = pc;

    final mediaStream = await (media == 'audio'
        ? _createAudioStream(peerID, media, isUserScreen)
        : _createVideoStream(peerID, media, isUserScreen));
    this._localStreams.add(mediaStream);
    mediaStream.getAudioTracks()[0].enableSpeakerphone(true);

    pc.addStream(mediaStream);

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      // print("adding ice candidate to peerID == $peerID");
      _wsSend('candidate', {
        'to': peerID,
        'from': this.myClientID,
        'candidate': candidate.toMap(),
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onAddStream = (MediaStream stream) {
      onAddRemoteStreamWrapper(peerID, stream);
      this._remoteStreams.add(stream);
    };

    pc.onRemoveStream = (MediaStream stream) {
      onRemoveRemoteStreamWrapper(peerID, stream);
      this._remoteStreams.removeWhere((it) => it.id == stream.id);
    };

    pc.onDataChannel = (channel) => _addDataChannel(peerID, channel);

    return pc;
  }

  void onRemoveRemoteStreamWrapper(String peerID, MediaStream stream) {
    // Fire callback
    onRemoveRemoteStream?.call(peerID, stream);

    // Update voip context if available
    voipContext?.withRemoteRenderers((remoteRenderers) {
      remoteRenderers[peerID]?.srcObject = null;
      remoteRenderers.remove(peerID);
    });
  }

  void onAddRemoteStreamWrapper(String peerID, MediaStream stream) async {
    // Fire callback
    onAddRemoteStream?.call(peerID, stream);

    // Update voip context if available
    if (voipContext != null) {
      final remoteRenderer = RTCVideoRenderer();
      await remoteRenderer.initialize();
      remoteRenderer.srcObject = stream;
      voipContext?.withRemoteRenderers((remoteRenderers) {
        remoteRenderers[peerID] = remoteRenderer;
      });
    }
  }

  void _addDataChannel(String peerID, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) =>
        this.onDataChannelMessage?.call(channel, data);

    this._dataChannels[peerID] = channel;

    this.onNewDataChannel?.call(channel);
  }

  void _createOffer(String refID, RTCPeerConnection pc, String media) async {
    try {
      RTCSessionDescription s = await pc
          .createOffer(media == 'audio' ? CONSTRAINTS_NO_VIDEO : CONSTRAINTS);
      pc.setLocalDescription(s);
      _wsSend('offer', {
        ...this.stdConnInfo,
        'to': refID,
        'description': s.toMap(),
        'roomID': this.session?.id,
        'media': media,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future _createAnswer(String id, RTCPeerConnection pc, String media) async {
    try {
      RTCSessionDescription s = await pc
          .createAnswer(media == 'audio' ? CONSTRAINTS_NO_VIDEO : CONSTRAINTS);
      pc.setLocalDescription(s);
      _wsSend('answer', {
        'to': id,
        'from': this.myClientID,
        'description': s.toMap(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void receiverConnected(String callerID) {
    print('receiver id $callerID');
    _wsSend('receiver_connected', {
      'to': callerID,
      'from': this.myClientID,
    });
  }

  Future getRoomInfo(String roomID) async {
    print("P2pCommManager.getRoomInfo $roomID");
    _wsSend('room.info', {
      ...this.stdConnInfo,
      'roomID': roomID,
    });
  }

  Future createRoom(KP2PSession session) async {
    print("P2pCommManager.createRoom");
    _wsSend('room.create', {
      ...this.stdConnInfo,
      ...(session.toJson()..removeWhere((_, v) => v == null)),
    });
  }

  Future joinRoom(String roomID) async {
    print("P2pCommManager.joinRoom - $roomID");
    _wsSend('room.join', {
      ...this.stdConnInfo,
      'roomID': roomID,
      "_nickname": KSessionData.me?.firstName,
    });
  }

  void acceptCallInvite(String callerID) {
    _wsSend('receiver_accept', {
      'to': callerID,
      'from': this.myClientID,
    });
  }

  void sendByeDevice(String callerID) => _wsSend('bye_device', {
        'to': callerID,
        'from': this.myClientID,
      });

  void _wsSend(String event, Map data) {
    final request = {"type": event, "data": data, "_cid": _wsCallID++};
    final json = jsonEncode(request);
    // print("WS OUT - $json");
    this._socket?.send(json);
  }

  void _answerTheCall(RTCPeerConnection pc) async {
    await _createAnswer(this._offerID!, pc, this._offerMedia!);
    this.onStateChange?.call(SignalingState.CallStateAccepted);
  }

  Future<Map<String, dynamic>> _getTurnCredential(String host, int port) async {
    // final String url =
    //     'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';
    // final response = await http.get(Uri.parse(url));
    //final responseBody = response.body;
    final responseBody = jsonEncode({
      "username": "xx",
      "password": "xx",
      "ttl": "86400",
      "uris": ["stun:stun.l.google.com:19302"],
    });
    print('getTurnCredential:response => $responseBody.');
    Map<String, dynamic> data = jsonDecode(responseBody);
    return data;
  }
}
