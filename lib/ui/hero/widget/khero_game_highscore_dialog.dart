import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/game/service/kgame_data.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KGameHighscoreDialog extends StatefulWidget {
  final Function onClose;
  final String game;
  final KGameScore? score;
  final bool? canSaveHighScore;
  final int currentLevel;
  final bool ascendingSort;
  final bool? isTime;
  final KGameData? gameData;
  final bool? isCurrentHighest;

  const KGameHighscoreDialog({
    required this.onClose,
    required this.game,
    this.score,
    this.gameData,
    this.canSaveHighScore = true,
    required this.currentLevel,
    this.ascendingSort = true,
    this.isTime = false,
    this.isCurrentHighest = false,
  });

  @override
  _KGameHighscoreDialogState createState() => _KGameHighscoreDialogState();
}

class _KGameHighscoreDialogState extends State<KGameHighscoreDialog> {
  List<KGameScore> get sortedScores {
    var gameScores = this.gameScores;
    // gameScores.sort((a, b) => widget.ascendingSort
    //     ? double.parse(a.score ?? "0").compareTo(double.parse(b.score ?? "0"))
    //     : double.parse(b.score ?? "0").compareTo(double.parse(a.score ?? "0")));
    return gameScores;
  }

  List<KGameScore> gameScores = [];
  bool isCurrentHighest = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.score != null) {
      gameScores.add(widget.score!);
    }
    loadScore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future saveScore() async {
    try {
      final result = await KServerHandler.saveGameScore(
        gameID: widget.game,
        level: widget.currentLevel.toString(),
        time: widget.score!.time,
        point: widget.score!.point,
        gameAppID: widget.gameData?.gameAppID,
        language: widget.gameData?.language ?? "en",
        topic: widget.gameData?.answerType ?? "number",
      );

      if (result.isSuccess) {
        setState(() {
          isCurrentHighest = true;
        });
      }
    } catch (e) {}
  }

  void loadScore() async {
    try {
      // if (widget.score != null && (widget.canSaveHighScore ?? true)) {
      //   await saveScore();
      // }

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
      height: MediaQuery.of(context).size.height * 0.6,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(5, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FittedBox(
                      child: Text(
                        "LEVEL ${widget.currentLevel + 1}",
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final score = scores[index];
                      bool isCurrentUserHighScore =
                          score.puid == KSessionData.me!.puid &&
                              (widget.isCurrentHighest ?? false);
                      print(score.scoreType);
                      return Container(
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
                                  bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.black54.withAlpha(50),
                                  ),
                                ),
                              ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${index < 9 ? '0' : ''}${index + 1}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 25,
                              child: KUserAvatar.fromUser(KUser()
                                ..puid = score.puid
                                ..avatarURL = score.avatarURL
                                ..kunm = score.kunm),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                score.kunm ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              (score.scoreType == 'time')
                                  ? '${(double.parse(score.score ?? '0') / 1000).toStringAsFixed(3)} s'
                                  : '${double.parse(score.score ?? '0')}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      );
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
