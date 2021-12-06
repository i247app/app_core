import 'package:app_core/ui/voip/kvoip_comm_manager.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class KVoipContext {
  Map<String, RTCVideoRenderer> remoteRenderers = {};
  RTCVideoRenderer? localRenderer;
  KVOIPCommManager? commManager;

  void dispose() {
    if (commManager != null && !commManager!.isDisposed) {
      commManager?.close();
      localRenderer?.dispose();
      remoteRenderers.forEach((_, rr) => rr.dispose());
    }
  }
}
