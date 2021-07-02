import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';

import 'host_config.dart';

abstract class CheckVersionHelper {
  static final ckVersion = NewVersion();
  static const bool BLOCKED_BANNERS_AS_TOAST = false;

  static Future<void> checkVersion(
      BuildContext context, bool isAlwaysDialog) async {
    final status = await ckVersion.getVersionStatus();
    if (!HostConfig.isReleaseMode && status != null) {
      print("version ${status.localVersion} store ${status.storeVersion}");
    }

    if (status != null && status.canUpdate) {
      ckVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'App Updates Available',
        dialogText:
            'Update to version ${status.storeVersion}',
        updateButtonText: 'Update',
        dismissButtonText: 'Later',
      );
    } else if (isAlwaysDialog) {
      final dialogTitleWidget = Text("No Updates Available");
      final dismissButtonTextWidget = Text("Ok");
      final dismissAction =
          () => Navigator.of(context, rootNavigator: true).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: dialogTitleWidget,
            actions: <Widget>[
              TextButton(
                child: dismissButtonTextWidget,
                onPressed: dismissAction,
              ),
            ],
          );
        },
      );
    }
  }
}
