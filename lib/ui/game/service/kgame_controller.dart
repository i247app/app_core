import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/game/games/kgame_count.dart';
import 'package:app_core/ui/game/games/kgame_grid_count.dart';
import 'package:app_core/ui/game/games/kgame_pick_number.dart';
import 'package:flutter/widgets.dart';
import 'kgame_data.dart';

class KGameController extends ValueNotifier<KGameData> {
  KGameController({
    required String gameID,
    String? gameAppID,
    String? gameName,
    String? answerType,
    int? currentLevel,
    bool? isSpeechGame,
    bool? isCountTime,
    bool? isUniqueAnswer,
  }) : super(KGameData(
          gameID: gameID,
          gameAppID: gameAppID,
          gameName: gameName,
          currentLevel: currentLevel,
          isSpeechGame: isSpeechGame,
          answerType: answerType,
          isCountTime: isCountTime,
          isUniqueAnswer: isUniqueAnswer,
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
      if (this.value.currentLevel == 0) {
        this.value.maxLevel = this.value.game?.maxLevel ?? 0;
        if ([KGameCount.GAME_ID, KGamePickNumber.GAME_ID].contains(this.value.gameID)) {
          this.value.maxLevel = 3;
        }
        if ([KGameGridCount.GAME_ID].contains(this.value.gameID)) {
          this.value.maxLevel = 4;
        }
        this.value.levelCount = (this.value.maxLevel ?? 0) > 0 ? this.value.maxLevel : 1;
        if (this.value.maxLevel != 0 && this.value.levelIconAssets.length != (this.value.levelCount ?? 0)) {
          this.value.levelIconAssets = List.generate(
            this.value.levelCount ?? 0,
                (index) => [
              KAssets.BULLET_BALL_GREEN,
              KAssets.BULLET_BALL_BLUE,
              KAssets.BULLET_BALL_ORANGE,
              KAssets.BULLET_BALL_RED,
            ][Math.Random().nextInt(4)],
          );
        }
        if (this.value.maxLevel != 0 && this.value.levelPlayTimes.length != (this.value.levelCount ?? 0)) this.value.levelPlayTimes = List.generate(this.value.levelCount ?? 0, (_) => 0);
        if (this.value.maxLevel != 0 && this.value.rates.length != (this.value.levelCount ?? 0)) this.value.rates = List.generate(this.value.levelCount ?? 0, (_) => null);
      }
      this.value.currentQuestionIndex = 0;
    } else {
      KSnackBarHelper.error("Can not get game data");
    }
    this.value.isLoading = false;
    notifyListeners();
  }
}
