import 'package:app_core/rem/mgr/rem_manager.dart';
import 'package:app_core/rem/rem.dart';

class REMCoreChatManager extends REMManager {
  static const String NOTIFY = "chat.notify";

  @override
  REMAction? dispatch(String path, Map<String, dynamic> data) {
    REMAction? action;
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

  REMAction defaultAction(Map<String, dynamic> json) => (nav) {
        print("huh?");
        return Future.value();
      };

  REMAction? onChatNotify({String? chatID, String? refApp, String? refID}) {
    REMAction? action;
    switch (refApp ?? "") {
      case "chat":
        if (chatID != null) action = _onNormalChatNotify(chatID);
        break;
    }
    return action;
  }

  REMAction? _onNormalChatNotify(String chatID) {
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
