import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/lingo/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class KAppVersionHelper {
  static final _versionPlugin = NewVersionPlus();

  static Future<VersionStatus?> getStatus() =>
      _versionPlugin.getVersionStatus();

  static Future<bool> isUpdateAvailable() async {
    bool result;
    try {
      final status = await getStatus();
      result = status!.canUpdate;
    } catch (_) {
      result = false;
    }
    return result;
  }

  static Future openStore() async {
    final status = await getStatus();
    final url = status?.appStoreLink;
    if (url != null && await canLaunch(url)) launch(url);
  }

  static Future<void> checkVersion(
    BuildContext context,
    bool showDialogWhenNoUpdate,
  ) async {
    final status = await _versionPlugin.getVersionStatus();

    if (status != null && status.canUpdate) {
      _versionPlugin.showUpdateDialog(
        context: context,
        versionStatus: status,
        allowDismissal: !(KSessionData.userSession?.isForceUpdate ?? false),
        dialogTitle: KPhrases.newUpdate,
        dialogText: '${KPhrases.updateContent} ${status.storeVersion}',
        updateButtonText: KPhrases.update,
        dismissButtonText: KPhrases.skip,
      );
    } else if (showDialogWhenNoUpdate) {
      final dialogTitleWidget = Text("No Update Available");
      final dismissButtonTextWidget = Text("Ok");

      return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: dialogTitleWidget,
            actions: <Widget>[
              TextButton(
                child: dismissButtonTextWidget,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}
