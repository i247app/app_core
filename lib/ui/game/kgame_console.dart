import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/ui/game/games/kgame_jump_multirow.dart';
import 'package:app_core/ui/game/games/kgame_jump_over.dart';
import 'package:app_core/ui/game/games/kgame_jump_up.dart';
import 'package:app_core/ui/game/games/kgame_letter_tap.dart';
import 'package:app_core/ui/game/games/kgame_moving_tap.dart';
import 'package:app_core/ui/game/games/kgame_multi_letter.dart';
import 'package:app_core/ui/game/games/kgame_shooting.dart';
import 'package:app_core/ui/game/games/kgame_speech_letter_moving_tap.dart';
import 'package:app_core/ui/game/games/kgame_speech_letter_tap.dart';
import 'package:app_core/ui/game/games/kgame_speech_moving_tap.dart';
import 'package:app_core/ui/game/games/kgame_speech_tap.dart';
import 'package:app_core/ui/game/games/kgame_tap.dart';
import 'package:app_core/ui/game/games/kgame_word.dart';
import 'package:app_core/ui/game/games/kgame_word_fortune.dart';
import 'package:app_core/ui/game/service/kgame_controller.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:app_core/ui/game/widget/kgame_level_end_dialog.dart';
import 'package:app_core/ui/game/widget/kgame_level_map.dart';
import 'package:app_core/ui/hero/widget/kegg_hero_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_count_down_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_pause_dialog.dart';
import 'package:app_core/ui/hero/widget/ktamago_chan_jumping.dart';
import 'package:app_core/ui/hero/widget/kword_game_intro.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

import 'games/kgame_multi.dart';

class KGameConsole extends StatefulWidget {
  final KGameController controller;
  final KHero? hero;

  const KGameConsole(this.controller, {this.hero});

  @override
  _KGameConsoleState createState() => _KGameConsoleState();
}

class _KGameConsoleState extends State<KGameConsole>
    with WidgetsBindingObserver {
  AudioPlayer backgroundAudioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  String? backgroundAudioFileUri;

  late FlutterTts flutterTts;

  static const List<String> BACKGROUND_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];

  String? gameBackground;
  int? overlayID;

  Timer? _timer;

  bool isBackgroundSoundPlaying = false;
  bool isShowCountDown = false;

  bool isShowEndLevel = false;
  bool isShowIntro = true;
  bool isLoaded = false;
  bool isCurrentHighest = false;
  bool isLocalMute = false;

  KGameData get gameData => widget.controller.value;

  bool get isStart => gameData.isStart ?? false;

  bool get isPause => gameData.isPause ?? false;

  bool get canAdvance => gameData.canAdvance ?? false;

  bool get canRestartGame => gameData.canRestartGame;

  int get currentLevel => gameData.currentLevel ?? 0;

  String get gameID => gameData.gameID;

  String? get gameAppID => gameData.gameAppID;

  KGameScore? get score => gameData.score;

  bool? get result => gameData.result;

  bool get isLoading => gameData.isLoading ?? false;

  bool get isSpeechGame => gameData.isSpeechGame ?? false;

  bool get isCountTime => gameData.isCountTime ?? false;

  List<int> get levelPlayTimes => gameData.levelPlayTimes;

  List<KQuestion> get questions => gameData.questions;

  int get levelCount => gameData.levelCount ?? 0;

  int get maxLevel => gameData.maxLevel ?? 0;

  int get rightAnswerCount => gameData.rightAnswerCount ?? 0;

  int get eggReceive => gameData.eggReceive ?? 0;

  int get point => gameData.point ?? 0;

  List<double> get levelHardness => gameData.levelHardness;

  String? get currentLanguage => gameData.language;

  int? get currentQuestionIndex => gameData.currentQuestionIndex;

  List<String> levelIconAssets = [];

  List<String> languageLabels = [];
  List<String> languageValues = [];

  List<KGameScore>? gameScores = null;

  @override
  void initState() {
    super.initState();

    levelIconAssets = List.generate(
      gameData.levelCount ?? 0,
      (index) => [
        KAssets.BULLET_BALL_GREEN,
        KAssets.BULLET_BALL_BLUE,
        KAssets.BULLET_BALL_ORANGE,
        KAssets.BULLET_BALL_RED,
      ][Math.Random().nextInt(4)],
    );

    loadAudioAsset();
    cacheHeroImages();

    this.gameBackground = ([...BACKGROUND_IMAGES]..shuffle()).first;

    widget.controller.addListener(basicSetStateListener);
    WidgetsBinding.instance?.addObserver(this);

    if (!isSpeechGame) {
      loadGame();
    } else {
      checkInstalledLanguage();
    }

    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (isStart && mounted && !isPause) {
        if (currentLevel < levelPlayTimes.length) {
          widget.controller.updatePlayTime();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    widget.controller.removeListener(basicSetStateListener);
    WidgetsBinding.instance?.removeObserver(this);

    backgroundAudioPlayer.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !this.isPause)
      showPauseDialog();
    else if (state == AppLifecycleState.resumed && this.isPause) resumeGame();
  }

  void checkInstalledLanguage() async {
    flutterTts = FlutterTts();

    try {
      if (Platform.isIOS) {
        await flutterTts.setSharedInstance(true);
      }
      await flutterTts.awaitSpeakCompletion(true);

      if (Platform.isAndroid) {
        try {
          final languages = await flutterTts.getLanguages;
          print(languages);
          bool isInstalled = await flutterTts
              .isLanguageInstalled(KLocaleHelper.TTS_LANGUAGE_VI);
          if (isInstalled) {
            this.setState(() {
              languageLabels.add("Vietnamese");
              languageValues.add(KLocaleHelper.LANGUAGE_VI);
            });
          }
        } catch (e) {}
        try {
          bool isInstalled = await flutterTts
              .isLanguageInstalled(KLocaleHelper.TTS_LANGUAGE_EN);
          if (isInstalled) {
            this.setState(() {
              languageLabels.add("English");
              languageValues.add(KLocaleHelper.LANGUAGE_EN);
            });
          }
        } catch (e) {}
      } else if (Platform.isIOS) {
        handleSelectLanguage(KLocaleHelper.LANGUAGE_EN);
        // List<dynamic> _languages = await flutterTts.getLanguages;
        //
        // if (_languages.contains(KLocaleHelper.TTS_LANGUAGE_VI)) {
        //   this.setState(() {
        //     languageLabels.add("Vietnamese");
        //     languageValues.add(KLocaleHelper.LANGUAGE_VI);
        //   });
        // }
        // if (_languages.contains(KLocaleHelper.TTS_LANGUAGE_EN)) {
        //   this.setState(() {
        //     languageLabels.add("English");
        //     languageValues.add(KLocaleHelper.LANGUAGE_EN);
        //   });
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  void loadGame() async {
    try {
      await widget.controller.loadGame();
    } catch (e) {}
  }

  void handleSelectLanguage(String language) {
    widget.controller.value.language = language;
    widget.controller.notify();

    loadGame();
  }

  void basicSetStateListener() => setState(() {});

  void loadAudioAsset() async {
    try {
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.LOOP);

      Directory tempDir = await getTemporaryDirectory();

      String backgroundAudioPath = getCurrentGameBackgroundAudioPath();
      ByteData backgroundAudioFileData =
          await rootBundle.load(backgroundAudioPath);

      File backgroundAudioTempFile =
          File('${tempDir.path}/game_background_audio.mp3');
      await backgroundAudioTempFile.writeAsBytes(
          backgroundAudioFileData.buffer.asUint8List(),
          flush: true);

      this.setState(() {
        this.backgroundAudioFileUri = backgroundAudioTempFile.uri.toString();
      });
    } catch (e) {}
  }

  void cacheHeroImages() async {
    try {
      for (int i = 0; i < KImageAnimationHelper.animationImages.length; i++) {
        await Future.wait(KImageAnimationHelper.animationImages
            .map((image) => DefaultCacheManager().getSingleFile(image)));
      }
    } catch (e) {
      print(e);
    }
  }

  void toggleBackgroundSound() {
    // if (isSpeechGame) {
    //   return;
    // }
    if (this.isBackgroundSoundPlaying) {
      this.setState(() {
        this.isBackgroundSoundPlaying = false;
      });
      this.widget.controller.toggleMuted(true);
      this.backgroundAudioPlayer.pause();
    } else {
      this.setState(() {
        this.isBackgroundSoundPlaying = true;
      });
      this.widget.controller.toggleMuted(false);
      this.backgroundAudioPlayer.resume();
    }
  }

  Future saveScore() async {
    try {
      final result = await KServerHandler.saveGameScore(
        gameID: gameID,
        level: currentLevel.toString(),
        time: score!.time,
        point: score!.point,
        gameAppID: gameAppID,
        language: gameData.language ?? "en",
        topic: gameData.answerType ?? "number",
      );

      if (result.isSuccess) {
        setState(() {
          isCurrentHighest = true;
        });
      }
      if (result.gameScores != null) {
        setState(() {
          gameScores = result.gameScores;
        });
      }
    } catch (e) {}
  }

  void showHeroGameEndOverlay(Function() onFinish) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    if (score != null &&
        (rightAnswerCount == questions.length ||
            gameID == KGameShooting.GAME_ID)) {
      await saveScore();
    }
    final heroGameEnd = KHeroGameEnd(
      gameData: gameData,
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: () {
        this.setState(() {
          this.isShowEndLevel = false;
        });
        if (this.overlayID != null) {
          KOverlayHelper.removeOverlay(this.overlayID!);
          this.overlayID = null;
        }
        onFinish();
      },
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(onFinish) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    if (score != null &&
        (rightAnswerCount == questions.length ||
            gameID == KGameShooting.GAME_ID)) {
      await saveScore();
    }
    final heroGameLevel = KTamagoChanJumping(
      gameData: gameData,
      onFinish: () {
        this.setState(() {
          this.isShowEndLevel = false;
        });
        if (this.overlayID != null) {
          KOverlayHelper.removeOverlay(this.overlayID!);
          this.overlayID = null;
        }
        onFinish();
      },
      canAdvance: canAdvance,
    );
    showCustomOverlay(heroGameLevel);
  }

  void showGameLevelEndOverlay() async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameHighScore = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: KGameLevelEndDialog(
            onClose: () {
              this.setState(() {
                this.isShowEndLevel = false;
              });
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
            },
            game: gameID,
            currentLevel: currentLevel,
            isTime: isShowTimer(),
            gameScores: gameScores,
            gameData: gameData,
            onPlay: () {
              this.setState(() {
                this.isShowEndLevel = false;
              });
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
              advanceGame(currentLevel);
            },
          ),
        ),
      ],
    );
    showCustomOverlay(heroGameHighScore);
  }

  void resumeGame() {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    if (!this.isBackgroundSoundPlaying && !isLocalMute) {
      toggleBackgroundSound();
    }
    widget.controller.togglePause(false);
  }

  void showPauseDialog() {
    if (this.isPause) return;
    if (this.isBackgroundSoundPlaying && !isLocalMute) {
      toggleBackgroundSound();
    }
    widget.controller.togglePause(true);
    final view = Align(
      alignment: Alignment.center,
      child: KGamePauseDialog(
        onExit: () {
          if (this.overlayID != null) {
            KOverlayHelper.removeOverlay(this.overlayID!);
            this.overlayID = null;
          }
          Navigator.of(context).pop();
        },
        onResume: resumeGame,
      ),
    );
    showCustomOverlay(view);
  }

  void showHighscoreDialog() async {
    if (this.isPause) return;
    // if (this.isBackgroundSoundPlaying) {
    //   toggleBackgroundSound();
    // }
    widget.controller.togglePause(true);
    final view = Align(
      alignment: Alignment.center,
      child: KGameHighscoreDialog(
        onClose: () {
          if (this.overlayID != null) {
            KOverlayHelper.removeOverlay(this.overlayID!);
            this.overlayID = null;
          }
          this.setState(() {
            isCurrentHighest = false;
          });
          resumeGame();
        },
        game: gameID,
        score: null,
        canSaveHighScore: false,
        currentLevel: currentLevel,
        gameData: gameData,
        isCurrentHighest: isCurrentHighest,
        gameScores: gameScores,
      ),
    );
    showCustomOverlay(view);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.6)),
        view,
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  void showCountDownOverlay() {
    this.setState(() {
      this.isShowCountDown = true;
    });
  }

  void start() {
    if (!isStart) {
      if (currentLevel == 0) {
        showCountDownOverlay();
      } else {
        widget.controller.toggleStart(true);
      }
    }
  }

  void advanceGame(int? level) async {
    try {
      if (level != null) {
        if (level < levelCount &&
            (rightAnswerCount / questions.length) >=
                levelHardness[currentLevel]) {
          widget.controller.value.currentLevel = level;
          await widget.controller.loadGame();

          widget.controller.value.isStart = true;
          widget.controller.value.result = null;
          widget.controller.value.point = 0;
          widget.controller.value.currentQuestionIndex = 0;
          widget.controller.value.rightAnswerCount = 0;
          widget.controller.value.wrongAnswerCount = 0;
          widget.controller.value.canAdvance = false;

          widget.controller.notify();
        }
      } else {
        if (currentLevel + 1 < levelCount &&
            (rightAnswerCount / questions.length) >=
                levelHardness[currentLevel]) {
          widget.controller.value.currentLevel = currentLevel + 1;
          await widget.controller.loadGame();

          widget.controller.value.isStart = true;
          widget.controller.value.result = null;
          widget.controller.value.point = 0;
          widget.controller.value.currentQuestionIndex = 0;
          widget.controller.value.rightAnswerCount = 0;
          widget.controller.value.wrongAnswerCount = 0;
          widget.controller.value.canAdvance = false;

          widget.controller.notify();
        }
      }
      this.setState(() {
        gameScores = null;
      });
    } catch (e) {}
  }

  void resetGame() async {
    try {
      widget.controller.value.currentLevel = 0;
      widget.controller.value.rightAnswerCount = 0;
      widget.controller.value.wrongAnswerCount = 0;
      widget.controller.value.point = 0;
      widget.controller.value.currentQuestionIndex = 0;
      widget.controller.value.eggReceive = 0;
      widget.controller.value.result = null;
      widget.controller.value.isStart = false;
      widget.controller.value.isMuted = false;
      widget.controller.value.isPause = false;
      widget.controller.value.levelPlayTimes = [];
      await widget.controller.loadGame();

      widget.controller.notify();
      this.setState(() {
        gameScores = null;
      });
    } catch (e) {}
  }

  void restartGame() async {
    try {
      widget.controller.value.levelPlayTimes[currentLevel] = 0;
      await widget.controller.loadGame();

      widget.controller.value.isStart = true;
      widget.controller.value.result = null;
      widget.controller.value.point = 0;
      widget.controller.value.currentQuestionIndex = 0;
      widget.controller.value.rightAnswerCount = 0;
      widget.controller.value.wrongAnswerCount = 0;
      widget.controller.value.canAdvance = false;

      widget.controller.notify();
      this.setState(() {
        gameScores = null;
      });
    } catch (e) {}
  }

  void onFinishLevel() {
    widget.controller.value.score = KGameScore()
      ..game = gameID
      ..avatarURL = KSessionData.me!.avatarURL
      ..kunm = KSessionData.me!.kunm
      ..level = "${currentLevel}"
      ..point = "${point}"
      ..time = "${levelPlayTimes[currentLevel]}"
      ..score = "${isShowTimer() ? levelPlayTimes[currentLevel] : point}";
    widget.controller.value.rates[currentLevel] = canAdvance
        ? (levelHardness[currentLevel] == 1
            ? ((rightAnswerCount / questions.length) * 3).floor()
            : ((((rightAnswerCount / questions.length) -
                            levelHardness[currentLevel]) /
                        (1 - levelHardness[currentLevel])) *
                    3)
                .floor())
        : 0;
    print(
        "abc ${widget.controller.value.rates[currentLevel]}");

    if (maxLevel == 0 && currentLevel + 1 == levelCount) {
      widget.controller.value.levelCount =
          (widget.controller.value.levelCount ?? 0) + 1;
      widget.controller.value.levelPlayTimes.add(0);
      widget.controller.value.rates.add(null);
      this.setState(() {
        levelIconAssets.add([
          KAssets.BULLET_BALL_GREEN,
          KAssets.BULLET_BALL_BLUE,
          KAssets.BULLET_BALL_ORANGE,
          KAssets.BULLET_BALL_RED,
        ][Math.Random().nextInt(4)]);
      });
    }

    widget.controller.notify();

    if (!canAdvance) {
      this.showHeroGameLevelOverlay(() {});
      return;
    }

    if (currentLevel + 1 < levelCount) {
      this.showHeroGameLevelOverlay(() {
        this.showGameLevelEndOverlay();
      });
    } else {
      this.showHeroGameEndOverlay(() {
        this.showGameLevelEndOverlay();
      });
    }
  }

  Widget getBottomBox() {
    switch (gameID) {
      case KGameShooting.GAME_ID:
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isStart || result != null)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 50,
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 30, right: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff2c1c44),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          "${(currentQuestionIndex ?? 0)}",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Color(0xfffdcd3a),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (currentLevel < levelIconAssets.length &&
                          levelIconAssets[currentLevel].isNotEmpty)
                        Positioned(
                          left: -30,
                          top: -15,
                          child: SizedBox(
                            height: 80,
                            child: Image.asset(
                              levelIconAssets[currentLevel],
                              fit: BoxFit.contain,
                              package: 'app_core',
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      default:
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isStart || result != null)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 50,
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 30, right: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff2c1c44),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          "${rightAnswerCount}",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Color(0xfffdcd3a),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (currentLevel < levelIconAssets.length &&
                          levelIconAssets[currentLevel].isNotEmpty)
                        Positioned(
                          left: -30,
                          top: -15,
                          child: SizedBox(
                            height: 80,
                            child: Image.asset(
                              levelIconAssets[currentLevel],
                              fit: BoxFit.contain,
                              package: 'app_core',
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
    }
  }

  String getCurrentGameBackgroundAudioPath() {
    switch (gameID) {
      case KGameMulti.GAME_ID:
      case KGameMultiLetter.GAME_ID:
        return "packages/app_core/assets/audio/music_soft_28s.mp3";
      case KGameJumpOver.GAME_ID:
      case KGameJumpUp.GAME_ID:
      // return "packages/app_core/assets/audio/music_quiz.mp3";
      case KGameShooting.GAME_ID:
        return "packages/app_core/assets/audio/music_swampy_110bpm.mp3";
      case KGameSpeechLetterTap.GAME_ID:
      case KGameSpeechTap.GAME_ID:
      case KGameSpeechMovingTap.GAME_ID:
      case KGameTap.GAME_ID:
      case KGameMovingTap.GAME_ID:
      case KGameLetterTap.GAME_ID:
      case KGameJumpMultiRow.GAME_ID:

      default:
        return "packages/app_core/assets/audio/music_arcade_loop.mp3";
    }
  }

  Widget getCurrentGameWidget() {
    switch (gameID) {
      case KGameSpeechLetterTap.GAME_ID:
        return KGameSpeechLetterTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameSpeechTap.GAME_ID:
        return KGameSpeechTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameSpeechMovingTap.GAME_ID:
        return KGameSpeechMovingTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameJumpOver.GAME_ID:
        return KGameJumpOver(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameTap.GAME_ID:
        return KGameTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameWord.GAME_ID:
        return KGameWord(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameWordFortune.GAME_ID:
        return KGameWordFortune(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameMovingTap.GAME_ID:
        return KGameMovingTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameLetterTap.GAME_ID:
        return KGameLetterTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameJumpUp.GAME_ID:
        return KGameJumpUp(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameJumpMultiRow.GAME_ID:
        return KGameMovingTap(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameShooting.GAME_ID:
        return KGameShooting(
          controller: widget.controller,
          hero: widget.hero,
          onFinishLevel: onFinishLevel,
        );
      case KGameMulti.GAME_ID:
        {
          if (currentLevel == 0 || currentLevel == 2) {
            return KGameSpeechTap(
              controller: widget.controller,
              hero: widget.hero,
              onFinishLevel: onFinishLevel,
            );
          }
          return KGameSpeechMovingTap(
            controller: widget.controller,
            hero: widget.hero,
            onFinishLevel: onFinishLevel,
          );
        }
      case KGameMultiLetter.GAME_ID:
        {
          if (currentLevel == 0 || currentLevel == 2) {
            return KGameSpeechLetterTap(
              controller: widget.controller,
              hero: widget.hero,
              onFinishLevel: onFinishLevel,
            );
          }
          return KGameSpeechLetterMovingTap(
            controller: widget.controller,
            hero: widget.hero,
            onFinishLevel: onFinishLevel,
          );
        }
      default:
        return Container();
    }
  }

  bool isShowTimer() {
    switch (gameID) {
      case KGameShooting.GAME_ID:
      case KGameWordFortune.GAME_ID:
      case KGameWord.GAME_ID:
        return false;
      case KGameMovingTap.GAME_ID:
      case KGameLetterTap.GAME_ID:
      case KGameTap.GAME_ID:
        return true;
      default:
        return true;
    }
  }

  Widget getGameIntro() {
    switch (gameID) {
      case KGameShooting.GAME_ID:
        return GestureDetector(
          onTap: () {
            this.setState(() => this.isShowIntro = false);
            if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
              this.setState(() {
                this.isBackgroundSoundPlaying = true;
              });
              backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                  isLocal: true);
            }
          },
          child: Container(
            child: KGameIntro(
              hero: widget.hero,
              onFinish: () {
                this.setState(() => this.isShowIntro = false);
                if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
                  this.setState(() {
                    this.isBackgroundSoundPlaying = true;
                  });
                  backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                      isLocal: true);
                }
              },
            ),
          ),
        );
      case KGameWord.GAME_ID:
      case KGameWordFortune.GAME_ID:
        return Stack(
          fit: StackFit.expand,
          children: [
            KWordGameIntro(onFinish: () {
              setState(() => this.isShowIntro = false);
              if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
                this.setState(() {
                  this.isBackgroundSoundPlaying = true;
                });
                backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                    isLocal: true);
              }
            }),
            GestureDetector(
              onTap: () {
                setState(() => this.isShowIntro = false);
                if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
                  this.setState(() {
                    this.isBackgroundSoundPlaying = true;
                  });
                  backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                      isLocal: true);
                }
              },
            ),
          ],
        );
      default:
        return Stack(
          fit: StackFit.expand,
          children: [
            KEggHeroIntro(onFinish: () {
              setState(() => this.isShowIntro = false);
              if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
                this.setState(() {
                  this.isBackgroundSoundPlaying = true;
                });
                backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                    isLocal: true);
              }
            }),
            GestureDetector(
              onTap: () {
                setState(() => this.isShowIntro = false);
                if (backgroundAudioPlayer.state != PlayerState.PLAYING) {
                  this.setState(() {
                    this.isBackgroundSoundPlaying = true;
                  });
                  backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                      isLocal: true);
                }
              },
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameIntro = getGameIntro();

    final timeCounter = Align(
      alignment: Alignment(-1, -1),
      child: currentLevel < levelPlayTimes.length
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Container(
                height: 50,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      KUtil.prettyStopwatchWithFraction(
                        Duration(
                          milliseconds: levelPlayTimes[currentLevel],
                        ),
                      ),
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );

    final scoreCounter = Align(
      alignment: Alignment(-1, -1),
      child: currentLevel < levelPlayTimes.length
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Container(
                height: 50,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${point}",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );

    final highscoreButton = InkWell(
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          Icons.star_border,
          color: Color(0xff2c1c44),
          size: 30,
        ),
      ),
      onTap: () => showHighscoreDialog(),
    );

    final soundButton = InkWell(
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          this.isBackgroundSoundPlaying ? Icons.volume_up : Icons.volume_off,
          color: Color(0xff2c1c44),
          size: 30,
        ),
      ),
      onTap: () {
        this.toggleBackgroundSound();
        this.setState(() {
          this.isLocalMute = !this.isBackgroundSoundPlaying;
        });
      },
    );

    final pauseButton = InkWell(
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          Icons.pause,
          color: Colors.red,
          size: 30,
        ),
      ),
      onTap: () => showPauseDialog(),
    );

    final countDown = KGameCountDownIntro(
      onFinish: () {
        if (mounted) {
          setState(() {
            isShowCountDown = false;
          });
          widget.controller.toggleStart(true);

          if (!(widget.controller.value.isMuted ?? false) &&
              backgroundAudioPlayer.state != PlayerState.PLAYING) {
            this.setState(() {
              this.isBackgroundSoundPlaying = true;
            });
            backgroundAudioPlayer.play(backgroundAudioFileUri ?? "",
                isLocal: true);
          }
        }
      },
    );

    final startScreen = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Level ${currentLevel + 1}",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () => start(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(2, 6),
                    ),
                  ],
                ),
                child: Text(
                  "START",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final gameOverScreen = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Game Over",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () => resetGame(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(2, 6),
                    ),
                  ],
                ),
                child: Text(
                  "RESTART",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(2, 6),
                    ),
                  ],
                ),
                child: Text(
                  "EXIT",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final levelMapScreen = Align(
      alignment: Alignment.center,
      child: KGameLevelMap(
        widget.controller,
        onTapLevel: (int? level) {
          if (result == null)
            start();
          else {
            if (result != null && canRestartGame) {
              if (level == currentLevel) {
                restartGame();
              } else {
                advanceGame(level);
              }
            }
          }
          // if (result == null) startScreen,
          // if (result != null && canRestartGame) advanceScreen,
          // if (!canRestartGame) gameOverScreen,
          print(level);
        },
        isEmbedded: true,
      ),
    );

    final advanceScreen = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${questions.length > 0 ? ((rightAnswerCount / questions.length) * 100).floor() : 0}% Correct",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            if (canAdvance) ...[
              GestureDetector(
                onTap: () => advanceGame(null),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    "NEXT LEVEL",
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => restartGame(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    "REPLAY LEVEL",
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            if (!canAdvance)
              GestureDetector(
                onTap: () => restartGame(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    "REPLAY LEVEL",
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    final eggReceiveBox = Align(
      alignment: Alignment(-1, 1),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (eggReceive > 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Image.asset(
                          KAssets.IMG_EGG,
                          width: 32,
                          height: 32,
                          package: 'app_core',
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "x",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${eggReceive}",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              Image.asset(
                KAssets.IMG_NEST,
                fit: BoxFit.fitWidth,
                package: 'app_core',
              ),
            ],
          ),
        ),
      ),
    );
    // final eggReceiveBox = Align(
    //   alignment: Alignment(-1, 1),
    //   child: Container(
    //     width: MediaQuery.of(context).size.width * 0.3,
    //     height: MediaQuery.of(context).size.height * 0.5,
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 4),
    //             child: GridView.count(
    //               shrinkWrap: true,
    //               crossAxisCount: 3,
    //               reverse: true,
    //               children: List.generate(eggReceive, (index) {
    //                 return Padding(
    //                   padding: EdgeInsets.only(top: 4),
    //                   child: Image.asset(
    //                     KAssets.IMG_EGG,
    //                     width: 32,
    //                     height: 32,
    //                     package: 'app_core',
    //                   ),
    //                 );
    //               }),
    //             ),
    //           ),
    //           Image.asset(
    //             KAssets.IMG_NEST,
    //             fit: BoxFit.fitWidth,
    //             package: 'app_core',
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    final languageSelect = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose your language",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            ...List.generate(languageLabels.length, (index) {
              final language = languageLabels[index];
              final languageValue = languageValues[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () => handleSelectLanguage(languageValue),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(2, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      "${language}",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );

    final currentGame = getCurrentGameWidget();

    final body = Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  BACKGROUND_IMAGES[currentLevel],
                  package: 'app_core',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: isShowIntro
                ? gameIntro
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      if (isShowTimer() && (isStart || result != null))
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: timeCounter,
                        ),
                      if (!isShowTimer() && (isStart || result != null))
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: scoreCounter,
                        ),
                      if (isStart)
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: eggReceiveBox,
                        ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: getBottomBox(),
                      ),
                      if (!isStart && isSpeechGame && currentLanguage == null)
                        languageSelect,
                      if (isStart && gameData.game != null && !isLoading)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: currentGame,
                          ),
                        ),
                      if ((!isSpeechGame || currentLanguage != null) &&
                          !isLoading &&
                          !isStart &&
                          !isShowCountDown &&
                          !isShowEndLevel) ...[
                        // if (result == null) startScreen,
                        // if (result != null && canRestartGame) advanceScreen,
                        if (!canRestartGame) gameOverScreen,
                        if (result == null || canRestartGame) levelMapScreen,
                      ],
                      if (!isPause)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                highscoreButton,
                                SizedBox(
                                  width: 10,
                                ),
                                soundButton,
                                SizedBox(
                                  width: 10,
                                ),
                                pauseButton,
                              ],
                            ),
                          ),
                        ),
                      if (isShowCountDown)
                        Align(
                          alignment: Alignment.center,
                          child: countDown,
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );

    return Scaffold(
      // appBar: AppBar(title: Text("Play game")),
      body: SafeArea(
        child: body,
      ),
    );
  }
}
