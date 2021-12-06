import 'package:app_core/ui/voip/kvoip_comm_manager.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class KVoipContext {
  Map<String, RTCVideoRenderer> remoteRenderers = {};
  RTCVideoRenderer? localRenderer;
  KVOIPCommManager? commManager;
}
