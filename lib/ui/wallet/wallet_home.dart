import 'package:app_core/header/kassets.dart';
import 'package:app_core/helper/klocale_helper.dart';
import 'package:app_core/helper/kmoney_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/ui/wallet/wallet_feed.dart';
import 'package:app_core/ui/widget/kqr_viewer.dart';
import 'package:flutter/material.dart';

@deprecated
class WalletHome extends StatefulWidget {
  final bool showBankButtons;
  final bool showDirectTransferButton;
  final bool showProxyTransferButton;

  const WalletHome({
    required this.showBankButtons,
    required this.showDirectTransferButton,
    required this.showProxyTransferButton,
  });

  @override
  State<StatefulWidget> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  String get defaultToken => KLocaleHelper.isUSA ? KMoney.USD : KMoney.VND;

  void showQR() {
    final qrData = {'puid': KSessionData.me?.puid ?? ""};
    final screen = KQRViewer(qrData: qrData);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final body = WalletFeed(
      defaultTokenName: defaultToken,
      showBankButtons: widget.showBankButtons,
      showDirectTransferButton: widget.showDirectTransferButton,
      showProxyTransferButton: widget.showProxyTransferButton,
    );

    final showQrButton = IconButton(
      onPressed: showQR,
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.white,
        ),
        child: Image.asset(KAssets.IMG_QR_CODE, package: 'app_core'),
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
