import 'package:app_core/rem/mgr/rem_manager.dart';
import 'package:app_core/rem/rem.dart';
import 'package:app_core/ui/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class AppCoreREMChatManager extends AppCoreREMManager {
  static const String NOTIFY = "chat.notify";

  @override
  AppCoreREMAction? dispatch(String path, Map<String, dynamic> data) {
    AppCoreREMAction? action;
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

  AppCoreREMAction defaultAction(Map<String, dynamic> json) => (nav) {
        print("huh?");
        return Future.value();
      };

  AppCoreREMAction? onChatNotify({String? chatID, String? refApp, String? refID}) {
    AppCoreREMAction? action;
    switch (refApp ?? "") {
      case "chat":
        // if (chatID != null) action = _onNormalChatNotify(chatID);
        break;
    }
    return action;
  }

  // CHAT chats
  // AppCoreREMAction _onNormalChatNotify(String chatID) {
  //   return (NavigatorState nav) async {
  //     final screen = ChatScreen(chatID: chatID);
  //     nav.pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (ctx) => screen),
  //       (r) => r.isFirst,
  //     );
  //   };
  // }
}
