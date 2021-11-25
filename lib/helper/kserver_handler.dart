import 'package:app_core/app_core.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/response/chat_add_members_response.dart';
import 'package:app_core/model/response/chat_remove_members_response.dart';
import 'package:app_core/model/response/credit_transfer_response.dart';
import 'package:app_core/model/response/get_balances_response.dart';
import 'package:app_core/model/response/get_chat_response.dart';
import 'package:app_core/model/response/get_chats_response.dart';
import 'package:app_core/model/response/get_credit_transactions_response.dart';
import 'package:app_core/model/response/get_users_response.dart';
import 'package:app_core/model/response/list_heroes_response.dart';
import 'package:app_core/model/response/resume_session_response.dart';
import 'package:app_core/model/response/search_users_response.dart';
import 'package:app_core/model/response/send_2fa_response.dart';
import 'package:app_core/model/response/send_chat_message_response.dart';

abstract class KServerHandler {
  static Future<SimpleResponse> logToServer(String key, value) async {
    final params = {
      "svc": "debug",
      "req": "log",
      key: value,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

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
        ..domain = await KUtil.getPackageName()
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

  static Future<KSend2faResponse> send2FACode({
    String? phone,
    String? email,
  }) async {
    final params = {
      "svc": "auth",
      "req": "gen.secpin",
      "phoneNumber": phone,
      "email": email,
    };
    return TLSHelper.send(params)
        .then((data) => KSend2faResponse.fromJson(data));
  }

  static Future<SimpleResponse> verify2FACode(String kpin) async {
    final params = {
      "svc": "auth",
      "req": "verify.secpin",
      "kpin": kpin,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<KListHeroesResponse> hatchHero({
    required String id,
    required String heroID,
  }) async {
    final params = {
      "svc": "bird",
      "req": "hero.hatch",
      "hero": KHero()
        ..id = id
        ..heroID = heroID,
    };
    return TLSHelper.send(params)
        .then((data) => KListHeroesResponse.fromJson(data));
  }

  static Future<KListHeroesResponse> getHeroes() async {
    final params = {
      "svc": "bird",
      "req": "hero.list",
    };
    return TLSHelper.send(params)
        .then((data) => KListHeroesResponse.fromJson(data));
  }

  static Future<SimpleResponse> modifyUserPersonal({
    String? firstName,
    String? middleName,
    String? lastName,
    String? avatarData,
    String? heroAvatarURL,
  }) async {
    final params = {
      "svc": "user",
      "req": "user.personal.modify",
      "user": KUser()
        ..firstName = firstName
        ..middleName = middleName
        ..lastName = lastName
        ..avatarImageData = avatarData
        ..heroAvatarURL = heroAvatarURL,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> createUserBank({
    required String bankID,
    required String bankName,
    required String bankAccNumber,
    required String bankAccName,
  }) async {
    final params = {
      "svc": "bird",
      "req": "create.tutor.bank",
      "bankID": bankID,
      "bankName": bankName,
      "bankAccNumber": bankAccNumber,
      "bankAccName": bankAccName,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> modifyUserBank({
    required String bankID,
    required String bankName,
    required String bankAccount,
    required String bankAccNumber,
  }) async {
    final params = {
      "svc": "user",
      "req": "user.bank.modify",
      "user": KUser()
        ..bankID = bankID
        ..bankName = bankName
        ..bankAccName = bankAccount
        ..bankAccNumber = bankAccNumber,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> bankDeposit({
    required String bankID,
    required String bankName,
    required String bankAccount,
    required String bankAccNumber,
    required double amount,
  }) async {
    final params = {
      "svc": "bird",
      "req": "bank.deposit",
      "amount": amount,
      "user": KUser()
        ..bankID = bankID
        ..bankName = bankName
        ..bankAccName = bankAccount
        ..bankAccNumber = bankAccNumber,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> bankWithdrawal({
    required String bankID,
    required String bankName,
    required String bankAccount,
    required String bankAccNumber,
    required double amount,
  }) async {
    final params = {
      "svc": "bird",
      "req": "bank.withdrawal",
      "amount": amount,
      "user": KUser()
        ..bankID = bankID
        ..bankName = bankName
        ..bankAccName = bankAccount
        ..bankAccNumber = bankAccNumber,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<ResumeSessionResponse> resumeSession(String? ktoken,
      [String? tag]) async {
    final params = {
      "svc": "auth",
      "req": "resume.session",
      "ktoken": ktoken,
      "tag": tag,
    };
    return TLSHelper.send(params)
        .then((data) => ResumeSessionResponse.fromJson(data));
  }

  // get by session on server myPUID() or perhaps by proxy puid
  static Future<GetCreditTransactionsResponse> getCreditTransactions({
    String? transactionID,
    String? lineID,
    String? puid, // TODO by proxy
    String? buid,
    String? storeID,
    String? page,
    String? tokenName,
  }) async {
    final params = {
      "svc": "chao",
      "req": "get.wallet.transactions",
      "txID": transactionID,
      "lineID": lineID,
      "puid": puid,
      "buid": buid,
      "storeID": storeID,
      "page": page,
      "tokenName": tokenName,
    };
    return TLSHelper.send(params)
        .then((data) => GetCreditTransactionsResponse.fromJson(data));
  }

  // Known Use
  // - get balances by user - tokenName optional
  // - get balance customer balance by business - requires tokenName, puid
  // perhaps, GetCreditBalancesResponse extends GetBalancesResponse
  static Future<GetBalancesResponse> getCreditBalances({
    String? fone, // ADMIN use or remove - also enforce security on server
    String? puid, // ADMIN use or remove - also enforce security on server
    String? tokenName,
  }) async {
    final params = {
      "svc": "chao",
      "req": "get.balances",
      "tokenName": tokenName,
      "puid": puid,
      "fone": fone,
    };
    return TLSHelper.send(params)
        .then((data) => GetBalancesResponse.fromJson(data));
  }

  static Future<CreditTransferResponse> transferCredit({
    required String puid,
    required String amount,
    String? tokenName,
  }) async {
    final params = {
      "svc": "chao",
      "req": "xfr.direct",
      "puid": puid,
      "amount": amount,
      "tokenName": tokenName,
    };
    return TLSHelper.send(params)
        .then((data) => CreditTransferResponse.fromJson(data));
  }
}
