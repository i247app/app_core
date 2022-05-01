import 'dart:math' as Math;

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KGameLevelEndDialog extends StatefulWidget {
  final Function onClose;
  final Function onPlay;
  final String game;
  final int currentLevel;
  final bool ascendingSort;
  final bool? isTime;
  final KGameData? gameData;
  final List<KGameScore>? gameScores;

  const KGameLevelEndDialog({
    required this.onClose,
    required this.onPlay,
    required this.game,
    this.gameData,
    this.gameScores,
    required this.currentLevel,
    this.ascendingSort = true,
    this.isTime = false,
  });

  @override
  _KGameLevelEndDialogState createState() => _KGameLevelEndDialogState();
}

class _KGameLevelEndDialogState extends State<KGameLevelEndDialog>
    with TickerProviderStateMixin {
  late Animation<Offset> _leftMoveUpAnimation,
      _midMoveUpAnimation,
      _rightMoveUpAnimation;

  late AnimationController _leftMoveUpAnimationController,
      _midMoveUpAnimationController,
      _rightMoveUpAnimationController,
      _spinAnimationController;

  bool isShowLeftStar = false;
  bool isShowMidStar = false;
  bool isShowRightStar = false;

  List<KGameScore> get sortedScores {
    var gameScores = this.gameScores;
    return gameScores;
  }

  List<KGameScore> gameScores = [];
  bool isCurrentHighest = false;
  bool isLoaded = false;

  List<int?> get rates => widget.gameData?.rates ?? [];

  int get rate => rates.length > widget.currentLevel ? (rates[widget.currentLevel] ?? 0) : 0;

  @override
  void initState() {
    super.initState();

    _spinAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (mounted && status == AnimationStatus.completed) {
              this._spinAnimationController.reset();
            } else if (status == AnimationStatus.dismissed) {}
          });

    _leftMoveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {}
      });
    _leftMoveUpAnimation = new Tween(begin: Offset(64, 50), end: Offset(0, 0))
        .animate(new CurvedAnimation(
            parent: _leftMoveUpAnimationController, curve: Curves.bounceOut));

    _rightMoveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {}
      });
    _rightMoveUpAnimation = new Tween(begin: Offset(-64, 50), end: Offset(0, 0))
        .animate(new CurvedAnimation(
            parent: _rightMoveUpAnimationController, curve: Curves.bounceOut));

    _midMoveUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) {}
      });
    _midMoveUpAnimation = new Tween(begin: Offset(0, 50), end: Offset(0, 0))
        .animate(new CurvedAnimation(
            parent: _midMoveUpAnimationController, curve: Curves.bounceOut));

    loadScore();

    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        // _spinAnimationController.forward();
        _leftMoveUpAnimationController.forward();
        this.setState(() {
          isShowLeftStar = true;
        });

        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            // _spinAnimationController.forward();
            _midMoveUpAnimationController.forward();
            this.setState(() {
              isShowMidStar = true;
            });

            Future.delayed(Duration(milliseconds: 100), () {
              if (mounted) {
                // _spinAnimationController.forward();
                _rightMoveUpAnimationController.forward();
                this.setState(() {
                  isShowRightStar = true;
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _midMoveUpAnimationController.dispose();
    _leftMoveUpAnimationController.dispose();
    _rightMoveUpAnimationController.dispose();
    _spinAnimationController.dispose();
    super.dispose();
  }

  void loadScore() async {
    try {
      if (widget.gameScores != null) {
        setState(() {
          gameScores = widget.gameScores!;
          isLoaded = true;
        });
        return;
      }

      final result = await KServerHandler.getGameHighscore(
        gameID: widget.game,
        level: widget.currentLevel.toString(),
      );

      if (result.isSuccess && result.gameScores != null) {
        setState(() {
          gameScores = result.gameScores!;
          isLoaded = true;
        });
      }
    } catch (e) {
      print(e);

      this.setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scores = sortedScores;
    final body = Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            KAssets.IMG_RANKING_BLUE,
            package: 'app_core',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(15, -5),
              child: InkWell(
                onTap: () => widget.onClose(),
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(5, -10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FittedBox(
                      child: Text(
                        "LEVEL ${widget.currentLevel + 1}",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: isShowLeftStar ? 1 : 0,
                              duration: Duration(milliseconds: 100),
                              child: Transform.translate(
                                offset: Offset(
                                  _leftMoveUpAnimation.value.dx,
                                  _leftMoveUpAnimation.value.dy,
                                ),
                                child: Transform.rotate(
                                  angle: -this._spinAnimationController.value *
                                      3 *
                                      Math.pi,
                                  child: Icon(
                                    rate >= 1 ? Icons.star : Icons.star_border,
                                    color: Colors.yellow,
                                    size: 64,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: isShowMidStar ? 1 : 0,
                              duration: Duration(milliseconds: 100),
                              child: Transform.translate(
                                offset: Offset(
                                  _midMoveUpAnimation.value.dx,
                                  _midMoveUpAnimation.value.dy,
                                ),
                                child: Transform.translate(
                                  offset: Offset(0, -15),
                                  child: Transform.rotate(
                                    angle:
                                        -this._spinAnimationController.value *
                                            3 *
                                            Math.pi,
                                    child: Icon(
                                      rate >= 2
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.yellow,
                                      size: 64,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: isShowRightStar ? 1 : 0,
                              duration: Duration(milliseconds: 100),
                              child: Transform.translate(
                                offset: Offset(
                                  _rightMoveUpAnimation.value.dx,
                                  _rightMoveUpAnimation.value.dy,
                                ),
                                child: Transform.rotate(
                                  angle: -this._spinAnimationController.value *
                                      3 *
                                      Math.pi,
                                  child: Icon(
                                    rate >= 3 ? Icons.star : Icons.star_border,
                                    color: Colors.yellow,
                                    size: 64,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => widget.onPlay(),
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
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
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "REPLAY",
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => widget.onClose(),
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
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
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "NEXT LEVEL",
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final score = scores[index];
                      bool isCurrentUserHighScore =
                          score.puid == KSessionData.me!.puid;
                      print(score.scoreType);
                      return Container(
                        width: 121,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        decoration: isCurrentUserHighScore
                            ? BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    width: 0.5,
                                    color: Colors.black54.withAlpha(50),
                                  ),
                                ),
                              ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: KUserAvatar.fromUser(KUser()
                                ..puid = score.puid
                                ..avatarURL = score.avatarURL
                                ..kunm = score.kunm
                                ..firstName = score.kunm),
                            ),
                            Expanded(child: Container()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  // color: Colors.black,
                                  child: FittedBox(
                                    // alignment: Align,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${index + 1}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(
                                        score.kunm ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 70,
                                      child: Text(
                                        (score.scoreType == 'time')
                                            ? '${(double.parse(score.score ?? '0') / 1000).toStringAsFixed(3)} s'
                                            : '${double.parse(score.score ?? '0')}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      if (index + 1 < scores.length) {
                        return SizedBox(
                          width: 10,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return body;
  }
}
