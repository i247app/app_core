import 'dart:convert';

import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/klocale_helper.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/ui/credit/widget/credit_feed.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreditHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreditHomeState();
}

class _CreditHomeState extends State<CreditHome> {
  String get defaultToken => KLocaleHelper.isUSA ? KMoney.USD : KMoney.VND;

  void showQR() {
    final qrData = {'puid': KSessionData.me?.puid ?? ""};
    final screen = Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  KSessionData.me?.businessName ??
                      KSessionData.me?.fullName ??
                      "",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(height: 16),
              QrImage(data: jsonEncode(qrData), backgroundColor: Colors.white),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${KSessionData.me?.kunm}"),
                  SizedBox(width: 20),
                  Text("${KSessionData.me?.puid}")
                ],
              )
            ],
          ),
        ),
      ),
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final body = CreditFeed(defaultTokenName: this.defaultToken);

    final showQrButton = IconButton(
      onPressed: showQR,
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
        ),
        child: Image.asset(
          KAssets.IMG_QR_CODE,
          package: 'app_core',
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.8),
        title: Text("Wallet"),
        actions: [showQrButton],
      ),
      body: body,
    );
  }
}
