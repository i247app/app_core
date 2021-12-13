import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/voip/kvoip_comm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum KVoipPerspective { sender, receiver }
enum KVoipCallState { ws_error, init, waiting, in_progress, ended }

class KVoipFlags {
  bool isMySoundEnabled = true;
  bool isMySpeakerEnabled = true;
  bool isMyCameraEnabled = true;
  bool isOtherSoundEnabled = true;
  bool isOtherCameraEnabled = true;
}

class KVoipContext extends ChangeNotifier {
  final String voipID;

  // Map<String, RTCVideoRenderer> remoteRenderers = {};
  // RTCVideoRenderer? localRenderer;
  MediaStream? localMedia;
  KVOIPCommManager? commManager;

  Map<String, MediaStream> remoteMedia = {};
  KVoipFlags flags = KVoipFlags();
  KVoipCallState callState;
  KVoipPerspective perspective;

  KVoipContext.sender(this.voipID)
      : perspective = KVoipPerspective.sender,
        callState = KVoipCallState.waiting;

  KVoipContext.receiver(this.voipID)
      : perspective = KVoipPerspective.receiver,
        callState = KVoipCallState.init;

  // /// Manipulate local renderer
  // void withLocalRenderer(void Function(RTCVideoRenderer? localRenderer) fn) {
  //   fn.call(localRenderer);
  //   notifyListeners();
  // }
  //
  // /// Manipulate remote renderers
  // void withRemoteRenderers(
  //     void Function(Map<String, RTCVideoRenderer> remoteRenderers) fn) {
  //   fn.call(remoteRenderers);
  //   notifyListeners();
  // }

  /// Manipulate local renderer
  void withLocalMedia(void Function(MediaStream? localMedia) fn) {
    fn.call(localMedia);
    notifyListeners();
  }

  /// Manipulate remote renderers
  void withRemoteMedia(void Function(Map<String, MediaStream> remoteMedia) fn) {
    fn.call(remoteMedia);
    notifyListeners();
  }

  /// Manipulate comm manager
  void withCommManager(void Function(KVOIPCommManager? commManager) fn) {
    fn.call(commManager);
    notifyListeners();
  }

  /// Manipulate flags
  void withFlags(void Function(KVoipFlags flags) fn) {
    fn.call(flags);
    notifyListeners();
  }

  // /// Change the call state
  // void setCallState(KVoipCallState callState) {
  //   this.callState = callState;
  //   notifyListeners();
  // }

  /// Close all resources
  void close() {
    commManager?.close();
    localMedia?.dispose();
    remoteMedia.forEach((_, rr) => rr.dispose());

    commManager = null;
    localMedia = null;
    remoteMedia.clear();

    notifyListeners();
  }

  /// Respond to comm manager state updates
  void onCommSignal(SignalingState signalState) {
    bool isNotifyRequired = false;
    if (perspective == KVoipPerspective.sender) {
      ///
      /// SENDER
      ///
      switch (signalState) {
        case SignalingState.CallStateNew:
          callState = KVoipCallState.waiting;
          isNotifyRequired = true;
          break;
        case SignalingState.CallStateRoomCreated:
          break;
        case SignalingState.CallStateRoomInfo:
          break;
        case SignalingState.CallStateRoomNewParticipant:
          break;
        case SignalingState.CallStateRoomEmpty:
          callState = KVoipCallState.ended;
          isNotifyRequired = true;
          close();
          break;
        case SignalingState.CallStateInvite:
          break;
        case SignalingState.CallStateAccepted:
          callState = KVoipCallState.in_progress;
          isNotifyRequired = true;
          break;
        case SignalingState.CallStateBye:
          callState = KVoipCallState.ended;
          isNotifyRequired = true;
          close();
          break;
        case SignalingState.CallStateRejected:
          callState = KVoipCallState.ended;
          isNotifyRequired = true;
          close();
          break;
        case SignalingState.ConnectionOpen:
          break;
        case SignalingState.ConnectionClosed:
          break;
      }
    } else if (perspective == KVoipPerspective.receiver) {
      ///
      /// RECEIVER
      ///
      switch (signalState) {
        case SignalingState.CallStateNew:
          break;
        case SignalingState.CallStateRoomCreated:
          break;
        case SignalingState.CallStateRoomInfo:
          callState = KVoipCallState.waiting;
          isNotifyRequired = true;
          break;
        case SignalingState.CallStateRoomNewParticipant:
          break;
        case SignalingState.CallStateRoomEmpty:
          callState = KVoipCallState.ended;
          isNotifyRequired = true;
          close();
          break;
        case SignalingState.CallStateInvite:
          break;
        case SignalingState.CallStateAccepted:
          callState = KVoipCallState.in_progress;
          isNotifyRequired = true;
          break;
        case SignalingState.CallStateBye:
        case SignalingState.CallStateRejected:
        case SignalingState.ConnectionOpen:
        case SignalingState.ConnectionClosed:
          break;
      }
    }
    if (isNotifyRequired) {
      notifyListeners();
    }
  }

  /// Notify other user to join call using push notification
  Future notifyWebRTCCall({
    required String refPUID,
    required String roomID,
    required List<String> invitePUIDs,
    required String uuid,
  }) async {
    final refPUIDs = [refPUID, ...invitePUIDs];
    final response = await KServerHandler.notifyWebRTCCall(
        refPUIDs: refPUIDs, callID: roomID, uuid: uuid);
    return response;
  }
}
