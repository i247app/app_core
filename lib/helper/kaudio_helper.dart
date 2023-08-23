import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

abstract class KAudioHelper {
  static AudioPlayer _audioPlayer = AudioPlayer();

  /// Play an audio file
  static Future<void> playAsset(String asset) async {
    final file = await _getImageFileFromAssets(asset);
    return _audioPlayer.play(DeviceFileSource(file.path), mode: PlayerMode.lowLatency);
  }

  static Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final filePath = tempPath +
        "/file_${KUtil.buildRandomString(1)}.tmp"; // file_01.tmp is dump file, can be anything
    final file = File(filePath);
    return file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}
