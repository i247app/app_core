import 'dart:convert';
import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:app_core/model/bank_withdrawal.dart';
import 'package:app_core/model/chapter.dart';
import 'package:app_core/model/course.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kcheck_in.dart';
import 'package:app_core/model/kgame.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/klead.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/model/lop_schedule.dart';
import 'package:app_core/model/response/chat_add_members_response.dart';
import 'package:app_core/model/response/chat_remove_members_response.dart';
import 'package:app_core/model/response/credit_transfer_response.dart';
import 'package:app_core/model/response/get_balances_response.dart';
import 'package:app_core/model/response/get_business_response.dart';
import 'package:app_core/model/response/get_chat_response.dart';
import 'package:app_core/model/response/get_chats_response.dart';
import 'package:app_core/model/response/get_credit_transactions_response.dart';
import 'package:app_core/model/response/get_games_response.dart';
import 'package:app_core/model/response/get_lop_schedules_response.dart';
import 'package:app_core/model/response/get_sales_leads_response.dart';
import 'package:app_core/model/response/get_scores_response.dart';
import 'package:app_core/model/response/get_users_response.dart';
import 'package:app_core/model/response/list_heroes_response.dart';
import 'package:app_core/model/response/list_textbooks_response.dart';
import 'package:app_core/model/response/list_xfr_proxy_response.dart';
import 'package:app_core/model/response/list_xfr_role_response.dart';
import 'package:app_core/model/response/old_schedules_response.dart';
import 'package:app_core/model/response/recent_users_response.dart';
import 'package:app_core/model/response/resume_session_response.dart';
import 'package:app_core/model/response/save_score_response.dart';
import 'package:app_core/model/response/search_users_response.dart';
import 'package:app_core/model/response/send_2fa_response.dart';
import 'package:app_core/model/response/send_chat_message_response.dart';
import 'package:app_core/model/share.dart';
import 'package:app_core/model/textbook.dart';
import 'package:app_core/model/xfr_proxy.dart';
import 'package:app_core/model/xfr_ticket.dart';
import 'package:app_core/ui/school/kdoc_picker.dart';

import '../model/response/share_response.dart';

abstract class KServerHandler {
  static Future<SimpleResponse> logToServer(String key, value) async {
    final params = {
      "svc": "debug",
      "req": "log",
      key: value,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> echoGoogleCrash(String googleCrash) async {
    final params = {
      "svc": "echo",
      "req": "echo.me",
      "googleCrash": googleCrash,
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

  static Future<RecentUsersResponse> recentsUsers() async {
    final params = {
      "svc": "auth",
      "req": "xfr.recent.users",
    };
    return TLSHelper.send(params)
        .then((data) => RecentUsersResponse.fromJson(data));
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
      "refPUIDs": refPUIDs.where((p) => p != KSessionData.me?.puid).toList(),
      "callID": "${callID}",
      "uuid": uuid,
      "call_type": "1",
      "caller_id": KSessionData.me!.puid!,
      "caller_name": KSessionData.me?.fullName,
      "call_opponents": "1",
      "session_id": uuid,
      "user_info": jsonEncode({"callID": callID})
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

  static Future<KGetGameScoresResponse> getGameHighscore({
    required String gameID,
    required String level,
  }) async {
    final params = {
      "svc": "game",
      "req": "game.score.get",
      "gameScore": KGameScore()
        ..game = gameID
        ..level = level,
    };
    return TLSHelper.send(params)
        .then((data) => KGetGameScoresResponse.fromJson(data));
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
    return TLSHelper.send(params, isDebug: true)
        .then((data) => SimpleResponse.fromJson(data));
  }

  static Future<KSaveScoreResponse> saveGameScore({
    required String gameID,
    required String level,
    String? time,
    String? point,
    String? gameAppID,
    String? language,
    String? topic,
  }) async {
    final params = {
      "svc": "game",
      "req": "game.score.save",
      "gameScore": KGameScore()
        ..game = gameID
        ..level = level
        ..time = time
        ..point = point
        ..gameAppID = gameAppID
        ..language = language
        ..topic = topic,
    };
    return TLSHelper.send(params)
        .then((data) => KSaveScoreResponse.fromJson(data));
  }

  static Future<CreditTransferResponse> bankDeposit({
    required String bankID,
    required String bankName,
    required String bankAccount,
    required String bankAccNumber,
    required String amount,
    required String tokenName,
  }) async {
    final params = {
      "svc": "chao",
      "req": "bank.deposit",
      "amount": amount,
      "tokenName": tokenName,
      "user": KUser()
        ..bankID = bankID
        ..bankName = bankName
        ..bankAccName = bankAccount
        ..bankAccNumber = bankAccNumber,
    };
    return TLSHelper.send(params)
        .then((data) => CreditTransferResponse.fromJson(data));
  }

  static Future<CreditTransferResponse> bankWithdrawal({
    required String bankID,
    required String bankName,
    required String bankAccount,
    required String bankAccNumber,
    required String amount,
    required String tokenName,
  }) async {
    final params = {
      "svc": "chao",
      "req": "bank.withdrawal",
      "bankWithdrawal": BankWithdrawal()
        ..bankID = bankID
        ..bankName = bankName
        ..bankAccountName = bankAccount
        ..bankAccountNumber = bankAccNumber
        ..amount = amount
        ..tokenName = tokenName,
    };
    return TLSHelper.send(params, isDebug: true)
        .then((data) => CreditTransferResponse.fromJson(data));
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
    required String tokenName,
    String? transactionID,
    String? lineID,
    String? puid, // TODO by proxy
    String? buid,
    String? storeID,
    String? page,
    String? proxyPUID,
  }) async {
    final params = {
      "svc": "chao",
      "req": "get.credit.transactions",
      "tokenName": tokenName,
      // "txID": transactionID,
      // "lineID": lineID,
      "puid": puid,
      "buid": buid,
      "storeID": storeID,
      "page": page,
      "proxyPUID": proxyPUID,
    };
    return TLSHelper.send(params)
        .then((data) => GetCreditTransactionsResponse.fromJson(data));
  }

  // get by session on server myPUID() or perhaps by proxy puid
  static Future<GetCreditTransactionsResponse> getTx({
    required String transactionID,
    required String lineID,
    String? proxyPUID,
  }) async {
    final params = {
      "svc": "chao",
      "req": "get.credit.transactions",
      "txID": transactionID,
      "lineID": lineID,
      "proxyPUID": proxyPUID,
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
    String? proxyPUID,
  }) async {
    final params = {
      "svc": "chao",
      "req": "get.balances",
      "tokenName": tokenName,
      "puid": puid,
      "fone": fone,
      "proxyPUID": proxyPUID,
    };
    return TLSHelper.send(params)
        .then((data) => GetBalancesResponse.fromJson(data));
  }

  static Future<CreditTransferResponse> xfrDirect(XFRTicket xfrTicket) async {
    final params = {
      "svc": "chao",
      "req": "xfr.direct",
      "xfrTicket": xfrTicket,
    };
    return TLSHelper.send(params)
        .then((data) => CreditTransferResponse.fromJson(data));
  }

  static Future<CreditTransferResponse> xfrProxy(XFRTicket xfrTicket) async {
    final params = {
      "svc": "chao",
      "req": "xfr.proxy",
      "xfrTicket": xfrTicket,
    };
    return TLSHelper.send(params)
        .then((data) => CreditTransferResponse.fromJson(data));
  }

  static Future<GetBusinessResponse> getBusiness(String buid) async {
    final params = {
      "svc": "biz",
      "req": "get.business",
      "buid": buid,
    };
    return TLSHelper.send(params)
        .then((data) => GetBusinessResponse.fromJson(data));
  }

  static Future<ListXFRRoleResponse> listXFRRoles() async {
    final params = {
      "svc": "chao",
      "req": "xfr.role.list",
    };
    return TLSHelper.send(params)
        .then((data) => ListXFRRoleResponse.fromJson(data));
  }

  static Future<ListXFRProxyResponse> listXFRProxy(String buid) async {
    final params = {
      "svc": "chao",
      "req": "xfr.proxy.list",
      "xfrProxy": XFRProxy()..buid = buid,
    };
    return TLSHelper.send(params)
        .then((data) => ListXFRProxyResponse.fromJson(data));
  }

  static Future<KGetGamesResponse> getGames({
    required String gameID,
    required String level,
    String? gameAppID,
    String? topic,
    String? language,
    String? mimeType,
  }) async {
    print(gameAppID);
    print("gameAppID");
    final params = {
      "svc": "game",
      "req": "game.get",
      "game": KGame()
        ..gameID = gameID
        ..gameAppID = gameAppID
        ..level = "$level"
        ..topic = topic ?? "number"
        ..mimeType = mimeType ?? "TEXT"
        ..language = language ?? "en",
    };
    return TLSHelper.send(params)
        .then((data) => KGetGamesResponse.fromJson(data));
  }

  static List<KQuestion> questionsMockup() {
    final questions = [
      "1 + 1",
      "3 + 2",
      "4 - 1",
      "4 + 5",
      "2 x 1",
      "2 x 3",
      "1 + 2 - 1",
      "4 + 8 - 5",
      "1 x 2 + 3",
      "1 + 2 x 3",
    ];
    final answers = [
      2,
      5,
      3,
      9,
      2,
      6,
      2,
      7,
      5,
      7,
    ];

    final _random = new Random();
    return List.generate(questions.length, (indexQuestion) {
      final correctIndex = _random.nextInt(3);
      final correctAnswer = answers[indexQuestion];
      var list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      return KQuestion()
        ..questionID = "q${indexQuestion + 1}"
        ..text = questions[indexQuestion]
        ..answers = List.generate(4, (index) {
          final dummyAnswer = list.removeAt(_random.nextInt(list.length));
          return KAnswer()
            ..answerID = "a${index + 1}"
            ..text = index == correctIndex
                ? correctAnswer.toString()
                : dummyAnswer.toString()
            ..isCorrect = index == correctIndex;
        });
    });
  }

  // requires puid or (refID/RefApp)
  static Future<SimpleResponse> pushFlash({
    String? refPUID,
    String? refID,
    String? refApp,
    required String flashType,
    required String mediaType,
    required String flashValue,
  }) async {
    final params = {
      "svc": "share",
      "req": "flash.notify",
      "refPUID": refPUID,
      "refID": refID,
      "refApp": refApp,
      "flashType": flashType,
      "mediaType": mediaType,
      "flashValue": flashValue,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> pushPage({
    required String? ssID,
    required String? index,
    String? refID,
    String? refApp,
    String? refPUID,
  }) async {
    final params = {
      "svc": "share",
      "req": "page.push",
      "ssID": ssID,
      "refPUID": refPUID,
      "refID": refID,
      "refApp": refApp,
      "index": index,
    };

    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> pushCurrentPage({
    required int pageIndex,
    String? scheduleID,
    // String? gigID,
  }) async {
    final params = {
      "svc": "bird",
      "req": "lop.page.push",
      "pageIndex": "$pageIndex",
      "scheduleID": scheduleID,
      // "gigID": gigID,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> startLopQuiz(String scheduleID) async {
    final params = {
      "svc": "bird",
      "req": "lop.answer.prompt.notify",
      "scheduleID": scheduleID,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> pushFlashToLopSchedule({
    required String scheduleID,
    required String flashType,
    required String mediaType,
    required String flashValue,
  }) async {
    final params = {
      "svc": "bird",
      "req": "lop.flash.notify",
      "scheduleID": scheduleID,
      "flashType": flashType,
      "mediaType": mediaType,
      "flashValue": flashValue,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<GetLopSchedulesResponse> listLopSchedules() async {
    final params = {
      "svc": "bird",
      "req": "lop.schedule.list",
    };
    return TLSHelper.send(params)
        .then((data) => GetLopSchedulesResponse.fromJson(data));
  }

  static Future<GetLopSchedulesResponse> getLopSchedule({
    required String lopID,
    required String scheduleID,
  }) async {
    final params = {
      "svc": "bird",
      "req": "lop.schedule.get",
      "lopSchedule": LopSchedule()
        ..lopID = lopID
        ..lopScheduleID = scheduleID,
    };
    return TLSHelper.send(params)
        .then((data) => GetLopSchedulesResponse.fromJson(data));
  }

  static Future<GetLopSchedulesResponse> modifyLopSchedule(
      LopSchedule schedule) async {
    final params = {
      "svc": "bird",
      "req": "lop.schedule.modify",
      "lopSchedule": schedule,
    };
    return TLSHelper.send(params)
        .then((data) => GetLopSchedulesResponse.fromJson(data));
  }

  static Future<OldSchedulesResponse> getCourses() async {
    final params = {
      "svc": "bird",
      "req": "course.list",
    };
    return TLSHelper.send(params)
        .then((data) => OldSchedulesResponse.fromJson(data));
  }

  static Future<OldSchedulesResponse> getCourse(String courseID) async {
    final params = {
      "svc": "bird",
      "req": "course.get",
      "course": Course()..courseID = courseID,
    };
    return TLSHelper.send(params)
        .then((data) => OldSchedulesResponse.fromJson(data));
  }

  static Future<ListTextbooksResponse> getListTextbook({
    int? grade,
    required KDocType type,
    int? chapter,
  }) async {
    final params = {
      "svc": "bird",
      "req": "headstart.picker",
      "textbook": Textbook()
        ..category = type == KDocType.headstart ? "HEADSTART" : "CLASS"
        ..grade = grade != null ? grade.toString() : null
        ..chapterNumber = (chapter != null) ? chapter.toString() : null
    };
    return TLSHelper.send(params)
        .then((data) => ListTextbooksResponse.fromJson(data));
  }

  static Future<ListTextbooksResponse> getTextbook({
    required String textbookID,
    required String chapterID,
  }) async {
    final params = {
      "svc": "bird",
      "req": "textbook.get",
      "textbook": Chapter()
        ..textbookID = textbookID
        ..chapterID = chapterID
    };
    return TLSHelper.send(params)
        .then((data) => ListTextbooksResponse.fromJson(data));
  }

  static Future<SimpleResponse> docPushPage({
    required String ssID,
    required String pageIndex,
  }) async {
    final params = {
      "svc": "bird",
      "req": "push.page",
      "ssID": ssID,
      "pageIndex": pageIndex,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  // requires shareID or (refID, refApp)
  static Future<ShareResponse> shareAction({
    String? ssID,
    required String refID,
    required String refApp,
    String? refPUID,
    String? textbookID,
    String? chapterID,
    String? role,
    String? action,
  }) async {
    final params = {
      "svc": "share",
      "req": "share.action",
      "share": Share()
        ..ssID = ssID
        ..refID = refID
        ..refApp = refApp
        ..refPUID = refPUID
        ..textbookID = textbookID
        ..chapterID = chapterID
        ..role = role
        ..action = action,
    };
    return TLSHelper.send(params).then((data) => ShareResponse.fromJson(data));
  }

  static Future<SimpleResponse> salesLeadsCheckin(KCheckIn checkIn) async {
    final domain = await KUtil.getPackageName();
    final params = {
      "svc": "auth",
      "req": "check.in",
      "checkIn": checkIn..kdomain = domain,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> salesLeadsCheckinStatus(
      KCheckIn checkIn) async {
    final domain = await KUtil.getPackageName();
    final params = {
      "svc": "auth",
      "req": "check.in.status",
      "checkIn": checkIn..kdomain = domain,
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> createSalesLead({required KLead lead}) async {
    final params = {
      "svc": "biz",
      "req": "sales.checkin",
      "lead": lead.toJson(),
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<SimpleResponse> modifySalesLead({required KLead lead}) async {
    final params = {
      "svc": "biz",
      "req": "modify.lead",
      "lead": lead.toJson(),
    };
    return TLSHelper.send(params).then((data) => SimpleResponse.fromJson(data));
  }

  static Future<KGetSalesLeadsResponse> getSalesLeads(
      {required KLead lead}) async {
    final params = {
      "svc": "biz",
      "req": "get.leads",
      "lead": lead.toJson(),
    };
    return TLSHelper.send(params)
        .then((data) => KGetSalesLeadsResponse.fromJson(data));
  }
}
