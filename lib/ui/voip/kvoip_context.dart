import 'package:app_core/ui/voip/kvoip_comm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class KVoipContext extends ChangeNotifier {
  Map<String, RTCVideoRenderer> remoteRenderers = {};
  RTCVideoRenderer? localRenderer;
  KVOIPCommManager? commManager;

  // Manipulate local renderer
  void withLocalRenderer(void Function(RTCVideoRenderer? localRenderer) fn) {
    fn.call(localRenderer);
    notifyListeners();
  }

  // Manipulate remote renderers
  void withRemoteRenderers(
      void Function(Map<String, RTCVideoRenderer> remoteRenderers) fn) {
    fn.call(remoteRenderers);
    notifyListeners();
  }

  // Manipulate comm manager
  void withCommManager(void Function(KVOIPCommManager? commManager) fn) {
    fn.call(commManager);
    notifyListeners();
  }

  // Close all resources
  void close() {
    if (commManager != null && !commManager!.isDisposed) {
      commManager?.close();
      localRenderer?.dispose();
      remoteRenderers.forEach((_, rr) => rr.dispose());
    }
  }
}
