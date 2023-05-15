import 'dart:convert';

import 'package:app_core/helper/ksession_data.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KQRViewer extends StatelessWidget {
  final Map<String, dynamic> qrData;

  const KQRViewer({required this.qrData});

  @override
  Widget build(BuildContext context) {
    final body = Scaffold(
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
              QrImageView(data: jsonEncode(qrData), backgroundColor: Colors.white),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${KSessionData.me?.kunm}"),
                  SizedBox(width: 20),
                  Text("${KSessionData.me?.puid}")
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return body;
  }
}
