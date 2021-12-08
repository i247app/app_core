import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/voip/kvoip_comm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
  Map<String, MediaStream> remoteMedia = {};
  MediaStream? localMedia;
  KVOIPCommManager? commManager;
  KVoipFlags flags = KVoipFlags();

  KVoipContext(this.voipID);

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

  /// Close all resources
  void close() {
    commManager?.close();
    localMedia?.dispose();
    remoteMedia.forEach((_, rr) => rr.dispose());

    commManager = null;
    localMedia = null;
    remoteMedia.clear();

    notifyListeners();

    // KVoipService.removeContext(voipID);
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
