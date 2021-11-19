import 'package:audioplayers/audioplayers.dart';

abstract class KAudioHelper {
  static AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  /// Play an audio file
  static Future<int> playAsset(String asset) async {
    return _audioPlayer.play(asset, isLocal: true);
  }
}
