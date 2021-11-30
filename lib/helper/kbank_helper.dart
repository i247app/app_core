import 'dart:convert';

import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/klocale_helper.dart';
import 'package:app_core/model/kbank.dart';
import 'package:app_core/model/response/get_banks_response.dart';
import 'package:flutter/services.dart';

abstract class KBankHelper {
  static Future<List<KBank>?> getBanks() async {
    final bankFile =
        KLocaleHelper.currentLocale.country == KLocaleHelper.COUNTRY_US
            ? KAssets.JSON_VIETNAM_BANKS
            : KAssets.JSON_VIETNAM_BANKS;
    final bankJsonString =
        await rootBundle.loadString("packages/app_core/$bankFile");
    Map<String, dynamic> bankJsonMap = json.decode(bankJsonString);
    final banksResponse = GetBanksResponse.fromJson(bankJsonMap);
    final banks = (banksResponse.banks ?? [])
        .where((bank) => bank.napasSupported ?? false)
        .toList();
    return Future.value(banks);
  }
}
