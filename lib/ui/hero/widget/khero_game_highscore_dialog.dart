import 'package:app_core/app_core.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KGameHighscoreDialog extends StatefulWidget {
  final Function onClose;
  final String game;
  final String? scoreID;
  final List<KGameScore> scores;
  final int currentLevel;
  final bool ascendingSort;

  const KGameHighscoreDialog({
    required this.onClose,
    required this.game,
    required this.scores,
    required this.currentLevel,
    this.scoreID,
    this.ascendingSort = true,
  });

  @override
  _KGameHighscoreDialogState createState() => _KGameHighscoreDialogState();
}

class _KGameHighscoreDialogState extends State<KGameHighscoreDialog> {
  List<KGameScore> get filteredScores => widget.scores
      .where((s) => (s.puid == KSessionData.me?.puid &&
          s.level == widget.currentLevel &&
          s.game == widget.game))
      .toList();

  List<KGameScore> get sortedScores {
    var scores = this.filteredScores;
    scores.sort((a, b) => widget.ascendingSort
        ? a.score!.compareTo(b.score!)
        : b.score!.compareTo(a.score!));
    return scores;
  }

  @override
  Widget build(BuildContext context) {
    final scores = this.sortedScores;
    final body = Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        // color: Colors.white,
        // borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.5),
        //     blurRadius: 8,
        //     offset: Offset(2, 6),
        //   ),
        // ],
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
                        "LEVEL ${widget.currentLevel}",
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
                      bool isCurrentLevel = widget.scoreID == score.scoreID;

                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        decoration: isCurrentLevel
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${((score.score ?? 0) / 1000).toStringAsFixed(3)} s',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
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
