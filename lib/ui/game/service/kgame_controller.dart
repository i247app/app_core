import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:flutter/widgets.dart';
import 'kgame_data.dart';

class KGameController extends ValueNotifier<KGameData> {
  KGameController({
    required String gameID,
    String? gameAppID,
    String? gameName,
    String? answerType,
    int? levelCount,
    int? currentLevel,
    bool? isSpeechGame,
    bool? isCountTime,
  }) : super(KGameData(
          gameID: gameID,
          gameAppID: gameAppID,
          gameName: gameName,
          levelCount: levelCount,
          currentLevel: currentLevel,
          isSpeechGame: isSpeechGame,
          answerType: answerType,
          isCountTime: isCountTime,
        ));

  void notify() {
    notifyListeners();
  }

  void togglePause(bool value) {
    this.value.isPause = value;
    notifyListeners();
  }

  void toggleMuted(bool value) {
    this.value.isMuted = value;
    notifyListeners();
  }

  void toggleStart(bool value) {
    this.value.isStart = value;
    notifyListeners();
  }

  void updatePlayTime() {
    this.value.levelPlayTimes[this.value.currentLevel ?? 0] += 16;
    notifyListeners();
  }

  Future loadGame() async {
    this.value.isLoading = true;
    notifyListeners();

    final response = await KServerHandler.getGames(
      gameID: this.value.gameID,
      gameAppID: this.value.gameAppID,
      level: (this.value.currentLevel ?? 0).toString(),
      topic: this.value.answerType ?? "number",
      mimeType: (this.value.isSpeechGame ?? false) ? "AUDIO" : "TEXT",
      language: this.value.language ?? "en",
    );

    if (response.isSuccess &&
        response.games != null &&
        response.games!.length > 0) {
      this.value.game = response.games![0];
      this.value.levelPlayTimes = List.filled(this.value.levelCount ?? 0, 0);
      this.value.currentQuestionIndex = 0;
    } else {
      KSnackBarHelper.error("Can not get game data");
    }
    this.value.isLoading = false;
    notifyListeners();
  }
}
