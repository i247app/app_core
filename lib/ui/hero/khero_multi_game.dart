import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kgame.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/hero/khero_jump_over_game.dart';
import 'package:app_core/ui/hero/khero_moving_tap_game.dart';
import 'package:app_core/ui/hero/khero_tap_game.dart';
import 'package:app_core/ui/hero/widget/kegg_hero_intro.dart';
import 'package:app_core/ui/hero/widget/khero_game_end.dart';
import 'package:app_core/ui/hero/widget/khero_game_highscore_dialog.dart';
import 'package:app_core/ui/hero/widget/khero_game_intro.dart';
import 'package:app_core/ui/hero/widget/ktamago_chan_jumping.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class KHeroMultiGame extends StatefulWidget {
  final KHero? hero;

  const KHeroMultiGame({this.hero});

  @override
  _KHeroMultiGameState createState() => _KHeroMultiGameState();
}

class _KHeroMultiGameState extends State<KHeroMultiGame>
    with WidgetsBindingObserver {
  static const GAME_NAME = "multi_game";
  static const GAME_ID = "590";

  GlobalKey<KJumpGameScreenState> _keyJumpOverGame = GlobalKey();
  GlobalKey<KJumpGameScreenState> _keyJumpGame = GlobalKey();
  GlobalKey<KMovingTapGameScreenState> _keyMovingTapGame = GlobalKey();
  GlobalKey<KShootingGameScreenState> _keyShootingGame = GlobalKey();
  GlobalKey<KTapGameScreenState> _keyTapGame = GlobalKey();

  static const List<String> BG_IMAGES = [
    KAssets.IMG_BG_COUNTRYSIDE_LIGHT,
    KAssets.IMG_BG_COUNTRYSIDE_DARK,
    KAssets.IMG_BG_SPACE_LIGHT,
    KAssets.IMG_BG_SPACE_DARK,
    KAssets.IMG_BG_XMAS_LIGHT,
    KAssets.IMG_BG_XMAS_DARK,
  ];

  int? overlayID;

  int totalLevel = 5;
  int currentLevel = 0;
  bool isShowEndLevel = false;
  bool isShowShootingIntro = false;
  bool isShowIntro = true;

  KGameScore? score;
  KGame? game = null;

  List<KQuestion> get questions => game?.qnas?[0].questions ?? [];
  bool isLoaded = false;

  String get gameBackground =>
      BG_IMAGES[Math.Random().nextInt(BG_IMAGES.length)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    loadGame();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _keyJumpGame.currentState?.showPauseDialog();
      _keyJumpOverGame.currentState?.showPauseDialog();
      _keyTapGame.currentState?.showPauseDialog();
      _keyMovingTapGame.currentState?.showPauseDialog();
      _keyShootingGame.currentState?.showPauseDialog();
    } else if (state == AppLifecycleState.resumed) {
      _keyJumpGame.currentState?.resumeGame();
      _keyJumpOverGame.currentState?.resumeGame();
      _keyTapGame.currentState?.resumeGame();
      _keyMovingTapGame.currentState?.resumeGame();
      _keyShootingGame.currentState?.resumeGame();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
  }

  loadGame() async {
    try {
      setState(() {
        this.isLoaded = false;
      });

      final response = await KServerHandler.getGames(
          gameID: GAME_ID, level: currentLevel.toString());

      if (response.isSuccess &&
          response.games != null &&
          response.games!.length > 0) {
        setState(() {
          this.game = response.games![0];
          this.isLoaded = true;
        });
      } else {
        KSnackBarHelper.error("Can not get game data");
      }
    } catch (e) {}
  }

  void showHeroGameEndOverlay(Function() onFinish) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameEnd = KHeroGameEnd(
      hero: KHero()..imageURL = KImageAnimationHelper.randomImage,
      onFinish: onFinish,
    );
    showCustomOverlay(heroGameEnd);
  }

  void showHeroGameLevelOverlay(Function() onFinish, {bool? canAdvance}) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameLevel =
        KTamagoChanJumping(onFinish: onFinish, canAdvance: canAdvance);
    showCustomOverlay(heroGameLevel);
  }

  void showHeroGameHighscoreOverlay(
      Function() onClose, bool? canSaveHighScore) async {
    this.setState(() {
      this.isShowEndLevel = true;
    });
    final heroGameHighScore = Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: KGameHighscoreDialog(
            onClose: onClose,
            game: GAME_ID,
            score: this.score,
            canSaveHighScore: canSaveHighScore,
            ascendingSort: false,
            currentLevel: currentLevel,
          ),
        ),
      ],
    );
    showCustomOverlay(heroGameHighScore);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.6)),
        Align(alignment: Alignment.topCenter, child: view),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    final jumpOverGame = KJumpGameScreen(
      key: _keyJumpOverGame,
      hero: widget.hero,
      totalLevel: totalLevel,
      isShowEndLevel: isShowEndLevel,
      questions: questions,
      level: currentLevel,
      isLoaded: isLoaded,
      onFinishLevel: (level, score, canAdvance) {
        if (!canAdvance) {
          this.showHeroGameLevelOverlay(() {
            this.setState(() {
              this.isShowEndLevel = false;
            });
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          }, canAdvance: canAdvance);
          return;
        }

        this.setState(() {
          this.score = KGameScore()
            ..game = GAME_ID
            ..avatarURL = KSessionData.me!.avatarURL
            ..kunm = KSessionData.me!.kunm
            ..level = "$level"
            ..score = "$score";
        });
        if (level < totalLevel) {
          this.showHeroGameLevelOverlay(() {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
            this.showHeroGameHighscoreOverlay(
              () {
                this.setState(() {
                  this.isShowEndLevel = false;
                });
                if (this.overlayID != null) {
                  KOverlayHelper.removeOverlay(this.overlayID!);
                  this.overlayID = null;
                }
              },
              true,
            );
          }, canAdvance: canAdvance);
        } else {
          this.showHeroGameEndOverlay(
            () {
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
              this.showHeroGameHighscoreOverlay(
                () {
                  this.setState(() {
                    this.isShowEndLevel = false;
                  });
                  if (this.overlayID != null) {
                    KOverlayHelper.removeOverlay(this.overlayID!);
                    this.overlayID = null;
                  }
                },
                true,
              );
            },
          );
        }
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentLevel = this.currentLevel + 1;
          this.isShowShootingIntro = true;
        });
        this.loadGame();
      }),
    );

    final shootingGame = KShootingGameScreen(
      key: _keyShootingGame,
      hero: widget.hero,
      totalLevel: totalLevel,
      isShowEndLevel: isShowEndLevel,
      questions: questions,
      level: currentLevel,
      isLoaded: isLoaded,
      onFinishLevel: (level, score, canAdvance) {
        if (!canAdvance) {
          this.showHeroGameLevelOverlay(() {
            this.setState(() {
              this.isShowEndLevel = false;
            });
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          }, canAdvance: canAdvance);
          return;
        }

        this.setState(() {
          this.score = KGameScore()
            ..game = GAME_ID
            ..avatarURL = KSessionData.me!.avatarURL
            ..kunm = KSessionData.me!.kunm
            ..level = "$level"
            ..score = "$score";
        });
        if (level < totalLevel) {
          this.showHeroGameLevelOverlay(() {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
            this.showHeroGameHighscoreOverlay(
              () {
                this.setState(() {
                  this.isShowEndLevel = false;
                });
                if (this.overlayID != null) {
                  KOverlayHelper.removeOverlay(this.overlayID!);
                  this.overlayID = null;
                }
              },
              true,
            );
          }, canAdvance: canAdvance);
        } else {
          this.showHeroGameEndOverlay(
            () {
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
              this.showHeroGameHighscoreOverlay(
                () {
                  this.setState(() {
                    this.isShowEndLevel = false;
                  });
                  if (this.overlayID != null) {
                    KOverlayHelper.removeOverlay(this.overlayID!);
                    this.overlayID = null;
                  }
                },
                true,
              );
            },
          );
        }
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentLevel = this.currentLevel + 1;
        });
        this.loadGame();
      }),
    );

    final jumpGame = KJumpGameScreen(
      key: _keyJumpGame,
      hero: widget.hero,
      totalLevel: totalLevel,
      isShowEndLevel: isShowEndLevel,
      questions: questions,
      level: currentLevel,
      isLoaded: isLoaded,
      onFinishLevel: (level, score, canAdvance) {
        if (!canAdvance) {
          this.showHeroGameLevelOverlay(() {
            this.setState(() {
              this.isShowEndLevel = false;
            });
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          }, canAdvance: canAdvance);
          return;
        }

        this.setState(() {
          this.score = KGameScore()
            ..game = GAME_ID
            ..avatarURL = KSessionData.me!.avatarURL
            ..kunm = KSessionData.me!.kunm
            ..level = "$level"
            ..score = "$score";
        });
        if (level < totalLevel) {
          this.showHeroGameLevelOverlay(() {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
            this.showHeroGameHighscoreOverlay(
              () {
                this.setState(() {
                  this.isShowEndLevel = false;
                });
                if (this.overlayID != null) {
                  KOverlayHelper.removeOverlay(this.overlayID!);
                  this.overlayID = null;
                }
              },
              true,
            );
          }, canAdvance: canAdvance);
        } else {
          this.showHeroGameEndOverlay(
            () {
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
              this.showHeroGameHighscoreOverlay(
                () {
                  this.setState(() {
                    this.isShowEndLevel = false;
                  });
                  if (this.overlayID != null) {
                    KOverlayHelper.removeOverlay(this.overlayID!);
                    this.overlayID = null;
                  }
                },
                true,
              );
            },
          );
        }
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentLevel = this.currentLevel + 1;
        });
        this.loadGame();
      }),
    );

    final tapGame = KTapGameScreen(
      key: _keyTapGame,
      hero: widget.hero,
      totalLevel: totalLevel,
      isShowEndLevel: isShowEndLevel,
      questions: questions,
      level: currentLevel,
      isLoaded: isLoaded,
      onFinishLevel: (level, score, canAdvance, canSaveHighScore) {
        if (!canAdvance) {
          this.showHeroGameLevelOverlay(() {
            this.setState(() {
              this.isShowEndLevel = false;
            });
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          }, canAdvance: canAdvance);
          return;
        }

        this.setState(() {
          this.score = KGameScore()
            ..game = GAME_ID
            ..avatarURL = KSessionData.me!.avatarURL
            ..kunm = KSessionData.me!.kunm
            ..level = "$level"
            ..score = "$score";
        });
        if (level < totalLevel) {
          this.showHeroGameLevelOverlay(() {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
            this.showHeroGameHighscoreOverlay(
              () {
                this.setState(() {
                  this.isShowEndLevel = false;
                });
                if (this.overlayID != null) {
                  KOverlayHelper.removeOverlay(this.overlayID!);
                  this.overlayID = null;
                }
              },
              canSaveHighScore,
            );
          }, canAdvance: canAdvance);
        } else {
          this.showHeroGameEndOverlay(
            () {
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
              this.showHeroGameHighscoreOverlay(
                () {
                  this.setState(() {
                    this.isShowEndLevel = false;
                  });
                  if (this.overlayID != null) {
                    KOverlayHelper.removeOverlay(this.overlayID!);
                    this.overlayID = null;
                  }
                },
                canSaveHighScore,
              );
            },
          );
        }
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentLevel = this.currentLevel + 1;
        });
        this.loadGame();
      }),
    );

    final tapMovingGame = KMovingTapGameScreen(
      key: _keyMovingTapGame,
      hero: widget.hero,
      totalLevel: totalLevel,
      isShowEndLevel: isShowEndLevel,
      questions: questions,
      level: currentLevel,
      isLoaded: isLoaded,
      onFinishLevel: (level, score, canAdvance, canSaveHighScore) {
        if (!canAdvance) {
          this.showHeroGameLevelOverlay(() {
            this.setState(() {
              this.isShowEndLevel = false;
            });
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
          }, canAdvance: canAdvance);
          return;
        }

        this.setState(() {
          this.score = KGameScore()
            ..game = GAME_ID
            ..avatarURL = KSessionData.me!.avatarURL
            ..kunm = KSessionData.me!.kunm
            ..level = "$level"
            ..score = "$score";
        });
        if (level < totalLevel) {
          this.showHeroGameLevelOverlay(() {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }
            this.showHeroGameHighscoreOverlay(
              () {
                this.setState(() {
                  this.isShowEndLevel = false;
                });
                if (this.overlayID != null) {
                  KOverlayHelper.removeOverlay(this.overlayID!);
                  this.overlayID = null;
                }
              },
              canSaveHighScore,
            );
          }, canAdvance: canAdvance);
        } else {
          this.showHeroGameEndOverlay(
            () {
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
              this.showHeroGameHighscoreOverlay(
                () {
                  this.setState(() {
                    this.isShowEndLevel = false;
                  });
                  if (this.overlayID != null) {
                    KOverlayHelper.removeOverlay(this.overlayID!);
                    this.overlayID = null;
                  }
                },
                canSaveHighScore,
              );
            },
          );
        }
      },
      onChangeLevel: (_) => this.setState(() {
        this.setState(() {
          this.currentLevel = this.currentLevel + 1;
        });
        this.loadGame();
      }),
    );

    final body = Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(this.gameBackground, package: 'app_core'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: !isLoaded || game == null
                ? Container()
                : (this.isShowIntro
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          if (this.isShowIntro) ...[
                            KEggHeroIntro(
                                onFinish: () =>
                                    setState(() => this.isShowIntro = false)),
                            GestureDetector(
                                onTap: () =>
                                    setState(() => this.isShowIntro = false)),
                          ],
                        ],
                      )
                    : SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: this.isShowShootingIntro
                                  ? GestureDetector(
                                      onTap: () => this.setState(() =>
                                          this.isShowShootingIntro = false),
                                      child: Container(
                                        child: KGameIntro(
                                          hero: widget.hero,
                                          onFinish: () => this.setState(() =>
                                              this.isShowShootingIntro = false),
                                        ),
                                      ),
                                    )
                                  : (currentLevel == 0
                                      ? jumpOverGame
                                      : (currentLevel == 1
                                          ? tapGame
                                          : (currentLevel == 2
                                              ? shootingGame
                                              : (currentLevel == 3
                                                  ? tapMovingGame
                                                  : (currentLevel == 4
                                                      ? jumpGame
                                                      : Container()))))),
                            ),
                          ],
                        ),
                      )),
          ),
        ),
      ],
    );

    return Scaffold(body: body);
  }
}
