import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kpeer_webrtc_helper.dart';
import 'package:app_core/model/kremote_peer.dart';
import 'package:app_core/network/http_helper.dart';
import 'package:app_core/ui/peer/widget/kpeer_button_view.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sb_peerdart/sb_peerdart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:queue/queue.dart';

class KPeerCall extends StatefulWidget {
  final String callId;

  const KPeerCall({
    Key? key,
    required this.callId,
  }) : super(key: key);

  @override
  State<KPeerCall> createState() => _KPeerCallState();
}

class _KPeerCallState extends State<KPeerCall> {
  final Queue queue = Queue();
  StreamSubscription? connectionStatusStreamSubscription;
  StreamSubscription? dataStreamSubscription;
  StreamSubscription? localPlayerStreamSubscription;
  StreamSubscription? remotePlayerStreamSubscription;

  final _localRenderer = RTCVideoRenderer();
  List<Map<String, dynamic>> _remoteRenderers = [];

  bool isCallSetting = false;
  bool inCall = false;
  bool isCalled = false;
  String? errorMsg;

  String get peerId => 'sb-${widget.callId}-${KSessionData.me?.puid}';

  bool isMySoundEnabled = true;
  bool isMySpeakerEnabled = true;
  bool isMyCameraEnabled = true;
  bool isBringMyCamBack = false;
  bool isPanelOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    KPeerWebRTCHelper.dispose();
    connectionStatusStreamSubscription?.cancel();
    dataStreamSubscription?.cancel();
    localPlayerStreamSubscription?.cancel();
    remotePlayerStreamSubscription?.cancel();
    queue.dispose();
    super.dispose();
  }

  void handleConnectionStatusUpdate(KPeerWebRTCStatus status) {
    if (mounted) {
      if (status == KPeerWebRTCStatus.CONNECTION && isCallSetting) {
        setState(() {
          isCallSetting = false;
          isCalled = true;
        });
      } else if (status == KPeerWebRTCStatus.CONNECTED) {
        setState(() {
          inCall = true;
        });
      }
    }
  }

  void handleLocalPlayerUpdate(mediaStream) async {
    if (mounted) {
      print('handleLocalPlayerUpdate');
      await _localRenderer.initialize();
      _localRenderer.srcObject = mediaStream;
    }
  }

  Future handleRemotePlayerUpdate(Map<String, dynamic> remotePeer) async {
    print('handleRemotePlayerUpdate ${new DateTime.now().toIso8601String()}');
    if (mounted) {
      final remotePeerId = remotePeer['peerID'];

      final index =
          _remoteRenderers.indexWhere((e) => e['peerID'] == remotePeerId);

      print(
          'remotePeer ${index} ${remotePeer} ${_remoteRenderers.map(((item) => item['peerID']))}');
      if (index == -1) {
        final _remotePeer = {
          ...remotePeer,
          'remoteRenderer': null,
          'metadata': {
            'isAudioEnable': false,
            'isVideoEnable': false,
            'displayName': '',
          }
        };
        if (remotePeer['stream'] != null) {
          final _remoteRenderer = RTCVideoRenderer();
          await _remoteRenderer.initialize();
          _remoteRenderer.srcObject = remotePeer['stream'];
          _remotePeer['remoteRenderer'] = _remoteRenderer;
        }

        _remoteRenderers.add(_remotePeer);
        this.setState(() {});
      } else {
        final _remotePeer = {
          ...remotePeer,
          'remoteRenderer': null,
          'metadata': {
            'isAudioEnable': false,
            'isVideoEnable': false,
            'displayName': '',
          }
        };
        if (remotePeer['stream'] != null) {
          final _remoteRenderer = RTCVideoRenderer();
          await _remoteRenderer.initialize();
          _remoteRenderer.srcObject = remotePeer['stream'];
          _remotePeer['remoteRenderer'] = _remoteRenderer;
        }

        _remoteRenderers[index] = _remotePeer;
        this.setState(() {});
      }

      sendMetadata([remotePeer['peer']]);
      sendDataPacket(
          [remotePeer['peer']],
          KPeerWebRTCHelper.PACKET_TYPE_RETRIEVE_METADATA,
          {
            'peerID': KPeerWebRTCHelper.localPeerId,
          });
      // calculateMaxVideoEachRow();
    }
  }

  void sendMetadata(List<KRemotePeer> peers) {
    sendDataPacket(peers, KPeerWebRTCHelper.PACKET_TYPE_METADATA, {
      'peerID': KPeerWebRTCHelper.localPeerId,
      'metadata': {
        'isAudioEnable': isMySoundEnabled,
        'isVideoEnable': isMyCameraEnabled,
        'displayName': KPeerWebRTCHelper.localDisplayName,
      },
    });
  }

  void sendDataPacket(
    List<KRemotePeer> remotePeers,
    String type,
    Map<String, dynamic> payload,
  ) async {
    Map<String, dynamic> packet = {
      'type': type,
      'payload': payload,
    };

    remotePeers.forEach((remotePeer) {
      final conn = KPeerWebRTCHelper.remotePeers
          .firstWhereOrNull((e) => e.peerID == remotePeer.peerID)
          ?.dataConnection;
      print('packet ${jsonEncode(packet)} ${conn?.peer} ${conn?.open}');
      if (conn != null && conn.open) {
        // print(Uint8List.fromList(jsonEncode(packet).codeUnits));
        conn.sendBinary(Uint8List.fromList(jsonEncode(packet).codeUnits));
      }
    });
  }

  void handleDataUpdate(Map<String, dynamic> data) {
    if (mounted) {
      final remotePeer = data['remotePeer'];
      final remotePeerData = data['data'];
      print('data ${remotePeer} ${remotePeerData}');

      switch (remotePeerData['type']) {
        case KPeerWebRTCHelper.PACKET_TYPE_METADATA:
          {
            final index = _remoteRenderers.indexWhere(
                (e) => e['peerID'] == remotePeerData['payload']['peerID']);
            if (index > -1 && data['payload']['metadata'] != null) {
              _remoteRenderers[index]['metadata'] = data['payload']['metadata'];
            } else {
              // retry set metadata
              Future.delayed(
                  Duration(milliseconds: 250), () => handleDataUpdate(data));
            }
          }
          break;
        case KPeerWebRTCHelper.PACKET_TYPE_RETRIEVE_METADATA:
          {
            final index = _remoteRenderers.indexWhere(
                (e) => e['peerID'] == remotePeerData['payload']['peerID']);
            if (index > -1 &&
                _remoteRenderers[index]['peer']['dataConnection'] != null) {
              sendMetadata([_remoteRenderers[index]['peer']]);
            } else {
              // retry set metadata
              Future.delayed(
                  Duration(milliseconds: 250), () => handleDataUpdate(data));
            }
          }
          break;
        default:
          print('Unrecognized data packet of type ${remotePeerData['type']}');
          break;
      }
    }
  }

  Future setupCall() async {
    setState(() {
      isCallSetting = true;
    });

    try {
      connectionStatusStreamSubscription = KPeerWebRTCHelper
          .connectionStatusStream
          .listen(handleConnectionStatusUpdate);
      dataStreamSubscription =
          KPeerWebRTCHelper.dataStream.listen(handleDataUpdate);
      localPlayerStreamSubscription =
          KPeerWebRTCHelper.localPlayerStream.listen(handleLocalPlayerUpdate);
      remotePlayerStreamSubscription = KPeerWebRTCHelper.remotePlayerStream
          .listen((data) async =>
              await queue.add(() => handleRemotePlayerUpdate(data)));

      final _localStream = await KPeerWebRTCHelper.retrieveLocalStream();
      print("_localStream, ${_localStream.id}");
      await KPeerWebRTCHelper.init(
        _localStream,
        localPeerID: this.peerId,
        auto: false,
        displayName: KSessionData.me?.fullName,
      );

      // Initiate call using sendCall function
      final remotePeers = await HTTPHelper.send(
        '/api/gigs/${widget.callId}/join',
        {},
        hostInfo: KHostInfo.raw('192.168.1.4', 8000),
      );

      final jsonData = jsonDecode(remotePeers.body);
      if (jsonData['data']?.length > 0) {
        KPeerWebRTCHelper.sendMultipleCalls(jsonData['data']
            .where((remotePeer) => remotePeer['peerjs_tag'] != this.peerId)
            .map((remotePeer) => remotePeer['peerjs_tag']));
      }
    } catch (ex) {
      print("ex ${ex}");
      setState(() {
        isCallSetting = false;
      });
    }
  }

  void safePop([final result]) {
    Navigator.of(context).pop(result);
  }

  void hangUp() {
    try {
      // stopCallerTune();
      // this.commManager?.sayGoodbye();
    } catch (e) {}
    safePop(true);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Hang up call?'),
            content: new Text('Cúp máy?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: hangUp,
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void onMicToggled(value) {
    setState(() {
      isMySoundEnabled = value;
    });

    final audioTrack = _localRenderer.srcObject?.getAudioTracks().first;
    if (audioTrack == null) return;

    audioTrack.enabled = value;
    sendMetadata(KPeerWebRTCHelper.remotePeers);
  }

  void onCameraToggled(value) {
    setState(() {
      isMyCameraEnabled = value;
    });

    final videoTrack = _localRenderer.srcObject?.getVideoTracks().first;
    if (videoTrack == null) return;

    videoTrack.enabled = value;
    sendMetadata(KPeerWebRTCHelper.remotePeers);
  }

  @override
  Widget build(BuildContext context) {
    print("localStream, ${_localRenderer.srcObject?.id}");
    print(KPeerWebRTCHelper.remotePeers.map((item) => item.peerID));
    // return Scaffold(
    //     appBar: AppBar(),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           _renderState(),
    //           const Text(
    //             'Connection ID:',
    //           ),
    //           SelectableText(peerId ?? ""),
    //           TextField(
    //             controller: _controller,
    //           ),
    //           ElevatedButton(onPressed: connect, child: const Text("connect")),
    //           ElevatedButton(
    //               onPressed: send, child: const Text("send message")),
    //           if (inCall)
    //             Expanded(
    //               child: RTCVideoView(
    //                 _localRenderer,
    //               ),
    //             ),
    //           if (inCall)
    //             Expanded(
    //               child: RTCVideoView(
    //                 _remoteRenderer,
    //               ),
    //             ),
    //         ],
    //       ),
    //     ));
    final callView = SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_localRenderer.srcObject != null) ...[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: RTCVideoView(
                        _localRenderer,
                        key: Key('${_localRenderer.srcObject!.id}'),
                      ),
                    ),
                  ],
                  if (_remoteRenderers.length > 0)
                    ...List.generate(_remoteRenderers.length, (index) {
                      final _remoteRenderer =
                          _remoteRenderers[index]['remoteRenderer'];

                      if (_remoteRenderer?.srcObject != null) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: RTCVideoView(
                            _remoteRenderer,
                            key: Key('${_remoteRenderer.srcObject!.id}'),
                          ),
                        );
                      }
                      return Container();
                    }).toList(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
            child: Container(
              width: 200.0,
              child: KPeerButtonView(
                isMicEnabled: this.isMySoundEnabled,
                isCameraEnabled: this.isMyCameraEnabled,
                type: KWebRTCCallType.video,
                onMicToggled: onMicToggled,
                onCameraToggled: onCameraToggled,
                onHangUp: hangUp,
              ),
            ),
          ),
        ],
      ),
    );
    // Stack(
    //   fit: StackFit.expand,
    //   children: <Widget>[
    //     ,
    //     Positioned(
    //       bottom: 20.0,
    //       left: 10.0,
    //       right: 10.0,
    //       child: SafeArea(
    //         child: Container(
    //           width: 200.0,
    //           child: KPeerButtonView(
    //             isMicEnabled: this.isMySoundEnabled,
    //             isCameraEnabled: this.isMyCameraEnabled,
    //             type: KWebRTCCallType.video,
    //             onMicToggled: onMicToggled,
    //             onCameraToggled: onCameraToggled,
    //             onHangUp: hangUp,
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );

    final endCallButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        KP2PButton(
          onClick: hangUp,
          backgroundColor: KStyles.colorBGNo,
          icon: Icon(Icons.call_end, color: KStyles.colorButtonText),
        ),
      ],
    );

    final callBackground = Stack(
      fit: StackFit.expand,
      children: [
        Icon(Icons.video_call, size: 300, color: Colors.green),
        Container(color: KStyles.black.withOpacity(0.8)),
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Container(
                width: 100,
                child: KUserAvatar.fromUser(KSessionData.me),
              ),
              SizedBox(height: 24),
              Text(
                "Connecting...",
                textAlign: TextAlign.center,
                style: KStyles.normalText.copyWith(color: KStyles.lightGrey),
              ),
            ],
          ),
        ),
      ],
    );

    final connectView = Container(
      color: KStyles.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          callBackground,
          Positioned(
            bottom: 20.0,
            left: 10.0,
            right: 10.0,
            child: SafeArea(
              child: Container(
                width: 200.0,
                child: endCallButtons,
              ),
            ),
          ),
        ],
      ),
    );

    final initView = Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      color: KStyles.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: isCallSetting ? null : setupCall,
            style: KStyles.roundedButton(
              Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
            ),
            child: isCallSetting
                ? CircularProgressIndicator()
                : Text(
                    "Join Call",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                  ),
          ),
        ],
      ),
    );

    final errorView = Container(
      color: KStyles.black.withOpacity(0.8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Video calling service is unavailable",
                  textAlign: TextAlign.center,
                  style: KStyles.largeXLText.copyWith(color: KStyles.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Please try again in a moment",
                  textAlign: TextAlign.center,
                  style: KStyles.normalText.copyWith(color: KStyles.white),
                ),
                if (!KHostConfig.isReleaseMode) ...[
                  SizedBox(height: 30),
                  Text(
                    "${errorMsg}",
                    textAlign: TextAlign.center,
                    style:
                        KStyles.normalText.copyWith(color: KStyles.colorError),
                  ),
                ],
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SafeArea(
                child: KP2PButton(
                  onClick: safePop,
                  backgroundColor: KStyles.colorBGNo,
                  icon: Icon(Icons.close, color: KStyles.colorButtonText),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final voipView;

    if (this.inCall) {
      voipView = callView;
    } else if (KStringHelper.isExist(errorMsg)) {
      voipView = errorView;
    } else if (!isCalled) {
      voipView = initView;
    } else {
      voipView = connectView;
    }

    final body = voipView;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: inCall || isCalled ? null : AppBar(),
        body: body,
      ),
    );
  }

  Widget _renderState() {
    Color bgColor = inCall ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = inCall ? "Connected" : "Standby";
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}
