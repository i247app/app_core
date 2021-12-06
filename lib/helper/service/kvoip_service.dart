import 'package:app_core/ui/voip/kvoip_context.dart';

abstract class KVoipService {
  static final Map<String, KVoipContext> _voipContexts = {};

  static void addContext(String id, KVoipContext context) {
    print("###### KVoipService.addContext id=$id");
    print("BEFORE _voipContexts.length == ${_voipContexts.length}");
    _voipContexts[id] = context;
    print("AFTER _voipContexts.length == ${_voipContexts.length}");
  }

  static KVoipContext? removeContext(String id) {
    print("###### KVoipService.removeContext id=$id");
    _voipContexts[id]?.dispose();
    _voipContexts.remove(id);
  }

  static KVoipContext? getContext(String id) => _voipContexts[id];

  static bool hasContext(String id) => getContext(id) != null;
}
