import 'package:app_core/header/kstyles.dart';
import 'package:flutter/widgets.dart';

class KNoticeData {
  final String message;
  final bool isSuccess;

  const KNoticeData(this.message, this.isSuccess);

  const KNoticeData.success(this.message) : this.isSuccess = true;

  const KNoticeData.error(this.message) : this.isSuccess = false;

  Text get widget => Text(
        this.message,
        style: KStyles.normalText.copyWith(
            color: this.isSuccess ? KStyles.colorSuccess : KStyles.colorError),
      );
}
