import 'package:app_core/rem/mgr/rem_chat_manager.dart';
import 'package:app_core/rem/mgr/rem_manager.dart';
import 'package:app_core/rem/rem.dart';

class AppCoreREMDispatcher extends AppCoreREMManager {
  @override
  AppCoreREMAction? dispatch(String path, Map<String, dynamic> data) {
    AppCoreREMPath pathSections = processPath(path);

    AppCoreREMManager? manager;
    switch (pathSections.head) {
      case AppCoreREM.CHAT:
        manager = AppCoreREMChatManager();
        break;
      default:
        manager = null;
        break;
    }

    return manager?.dispatch(pathSections.full, data);
  }
}
