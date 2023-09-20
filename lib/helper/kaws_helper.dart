import 'dart:async';
import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/model/kaws_info.dart';
import 'package:aws_s3_upload/aws_s3_upload.dart';

abstract class KAWSHelper {
  static Future<String?> uploadFile(
    File file, {
    KAWSInfo? awsInfo,
    String region = "us-west-1",
    String? fileDest,
    String? fileName,
  }) async {
    try {
      KAWSInfo? _awsInfo = awsInfo ?? KSessionData.userSession?.awsInfo;

      if (_awsInfo != null &&
          KStringHelper.isExist(_awsInfo.accessKey) &&
          KStringHelper.isExist(_awsInfo.secretKey) &&
          KStringHelper.isExist(_awsInfo.bucketName)) {
        final uploadedPath = await AwsS3.uploadFile(
            accessKey: _awsInfo.accessKey!,
            secretKey: _awsInfo.secretKey!,
            file: file,
            bucket: _awsInfo.bucketName!,
            region: region,
            destDir: fileDest ?? '',
            filename: fileName,
            metadata: {} // optional
            );

        if (KStringHelper.isExist(uploadedPath)) {
          return uploadedPath;
        }
      }
    } catch (ex) {
      print('AWS upload failed ${ex}');
    }
    return null;
  }
}
