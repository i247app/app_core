import 'package:app_core/rem/mgr/krem_manager.dart';
import 'package:app_core/rem/krem.dart';

class KREMCoreChatManager extends KREMManager {
  static const String NOTIFY = "chat.notify";

  @override
  KREMAction? dispatch(String path, Map<String, dynamic> data) {
    KREMAction? action;
    switch (path) {
      case NOTIFY:
        action = onChatNotify(
          chatID: data["id"],
          refApp: data["refApp"],
          refID: data["refID"],
        );
        break;
      default:
        action = defaultAction(data);
        break;
    }
    return action;
  }

  KREMAction defaultAction(Map<String, dynamic> json) => (nav) {
        print("huh?");
        return Future.value();
      };

  KREMAction? onChatNotify({String? chatID, String? refApp, String? refID}) {
    KREMAction? action;
    switch (refApp ?? "") {
      case "chat":
        if (chatID != null) action = _onNormalChatNotify(chatID);
        break;
    }
    return action;
  }

  KREMAction? _onNormalChatNotify(String chatID) {
    return null;
    // return (NavigatorState nav) async {
    //   final screen = KChatScreen(chatID: chatID);
    //   nav.pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (ctx) => screen),
    //     (r) => r.isFirst,
    //   );
    // };
  }
}
