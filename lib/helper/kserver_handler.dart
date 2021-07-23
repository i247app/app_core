import 'package:app_core/app_core.dart';
import 'package:app_core/model/response/chat_add_members_response.dart';
import 'package:app_core/model/response/chat_remove_members_response.dart';
import 'package:app_core/model/response/get_chat_response.dart';
import 'package:app_core/model/response/get_chats_response.dart';
import 'package:app_core/model/response/get_users_response.dart';
import 'package:app_core/model/response/search_users_response.dart';
import 'package:app_core/model/response/send_chat_message_response.dart';

abstract class KServerHandler {
  // chats
  static Future<KGetChatsResponse> getChats() async {
    final params = {
      "svc": "chat",
      "req": "chat.list",
    };
    return TLSHelper.send(params)
        .then((data) => KGetChatsResponse.fromJson(data));
  }

  static Future<GetChatResponse> getChat({
    String? chatID,
    String? refApp,
    String? refID,
  }) async {
    final params = {
      "svc": "chat",
      "req": "chat.get",
      "chat": KChat()
        ..refApp = refApp
        ..refID = refID
        ..chatID = chatID,
    };
    return TLSHelper.send(params)
        .then((data) => GetChatResponse.fromJson(data));
  }

  static Future<SimpleResponse> removeChat(
    String chatID,
    String? refApp,
    String? refID,
  ) async {
    final params = {
      "svc": "chat",
      "req": "chat.remove",
      "chat": KChat()
        ..refApp = refApp
        ..refID = refID
        ..chatID = chatID,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  //
  // static Future<GetChatMessagesResponse> getChatMessages({
  //   String? chatID,
  //   String? appContent,
  //   String? appContentID,
  //   String? messageID,
  // }) async {
  //   final params = {
  //     "svc": "chat",
  //     "req": "chat.message.list",
  //     "chatID": chatID,
  //     "refApp": appContent,
  //     "refID": appContentID,
  //     "messageID": messageID,
  //   };
  //   return TLSHelper.send(params)
  //       .then((data) => GetChatMessagesResponse.fromJson(data));
  // }
  //
  static Future<SendChatMessageResponse> sendMessage(KChatMessage msg,
      {List<String>? refPUIDs}) async {
    final params = {
      "svc": "chat",
      "req": "chat.message.send",
      "members": refPUIDs?.map((puid) => KChatMember()..puid = puid).toList(),
      "chatMessage": msg,
    };
    return TLSHelper.send(params)
        .then((data) => SendChatMessageResponse.fromJson(data));
  }

//
// static Future<GetChatMembersResponse> getChatMembers(
//     {String? chatID, String? appContent, String? appContentID}) async {
//   final params = {
//     "svc": "chat",
//     "req": "chat.member.list",
//     "chatID": chatID,
//     "refApp": appContent,
//     "refID": appContentID,
//   };
//   return TLSHelper.send(params)
//       .then((data) => GetChatMembersResponse.fromJson(data));
// }
//
  static Future<ChatAddMembersResponse> addChatMembers({
    required String chatID,
    required List<String> refPUIDs,
    String? refApp,
    String? refID,
  }) async {
    final params = {
      "svc": "chat",
      "req": "chat.member.add",
      "members": refPUIDs
          .map((puid) => KChatMember()
            // ..domain = domain
            ..refApp = refApp
            ..refID = refID
            ..chatID = chatID
            ..puid = puid)
          .toList(),
    };
    return TLSHelper.send(params)
        .then((data) => ChatAddMembersResponse.fromJson(data));
  }

//
  static Future<KChatRemoveMembersResponse> removeChatMembers(
    String chatID,
    List<String> refPUIDs,
    String? refApp,
    String? refID,
  ) async {
    final domain = await KUtil.getPackageName();
    final params = {
      "svc": "chat",
      "req": "chat.member.remove",
      "members": refPUIDs
          .map((puid) => KChatMember()
            ..domain = domain
            ..refApp = refApp
            ..refID = refID
            ..chatID = chatID
            ..puid = puid)
          .toList(),
    };
    return TLSHelper.send(params)
        .then((data) => KChatRemoveMembersResponse.fromJson(data));
  }

  static Future<GetUsersResponse> getUsers({
    String? puid,
    String? fone,
  }) async {
    final params = {
      "svc": "user",
      "req": "get.user",
      "puid": puid,
      "fone": fone,
    };
    return TLSHelper.send(params)
        .then((data) => GetUsersResponse.fromJson(data));
  }

  static Future<SearchUsersResponse> searchUsers(String searchText) async {
    final params = {
      "svc": "auth",
      "req": "search.users",
      "searchText": searchText,
    };
    return TLSHelper.send(params)
        .then((data) => SearchUsersResponse.fromJson(data));
  }

  static Future<SimpleResponse> notifyWebRTCCall({
    required List<String> refPUIDs,
    required String callID,
    required String uuid,
    // String? callType,
  }) async {
    final params = {
      "svc": "chat",
      "req": "webrtc.call.notify",
      "notifyType": "voip",
      "refPUIDs": refPUIDs
          .where((element) => element != KSessionData.me?.puid)
          .toList(),
      "callID": callID,
      "uuid": uuid,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }
}
