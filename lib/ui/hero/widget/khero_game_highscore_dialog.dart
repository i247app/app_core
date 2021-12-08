import 'dart:math';

import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KGameHighscoreDialog extends StatefulWidget {
  final Function onClose;
  final List<int>? scores;
  final int? currentLevel;

  const KGameHighscoreDialog(
      {required this.onClose, this.scores, this.currentLevel});

  @override
  _KGameHighscoreDialogState createState() => _KGameHighscoreDialogState();
}

class _KGameHighscoreDialogState extends State<KGameHighscoreDialog> {
  List<int> scores = [];

  int? get currentLevelScore =>
      widget.scores != null && widget.currentLevel != null
          ? widget.scores![widget.scores!.length - 1]
          : null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final _scores = widget.scores ?? [];
    _scores.sort();
    this.setState(() {
      scores = _scores;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(5, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: FittedBox(
                      child: Text(
                        "HIGH SCORES",
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
                      bool isCurrentLevel = currentLevelScore == scores[index];

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
                          children: [
                            Text(
                              "${index < 9 ? '0' : ''}${index + 1}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 25,
                              child: KUserAvatar.fromUser(KSessionData.me),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                KSessionData.userSession?.user?.kunm ?? "",
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
                              '${scores[index]}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
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
