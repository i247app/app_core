import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kgame.dart';
import 'package:app_core/model/kgame_score.dart';
import 'package:app_core/model/kquestion.dart';

class KGameData {
  String gameID;
  String? gameAppID;
  String? gameName;
  String? answerType;
  String? language;
  int? levelCount;
  int? currentLevel;
  KGame? game;
  KGameScore? score;
  int? rightAnswerCount;
  int? wrongAnswerCount;
  double? baseLevelHardness;
  int? point;
  int? currentQuestionIndex;
  int? eggReceive;
  bool? result;
  bool? isStart;
  bool? isPause;
  bool? canAdvance;
  bool? isLoading;
  bool? isSpeechGame;
  bool? isCountTime;

  bool get isInitializing => this.game == null;

  List<double> get levelHardness => List.generate(
        this.levelCount ?? 0,
        (index) => (baseLevelHardness ?? 0) + (index * 0.1),
      );
  List<int> levelPlayTimes = [];

  List<KQuestion> get questions => this.game?.qnas?[0].questions ?? [];

  KQuestion get currentQuestion => this.questions.length > 0 &&
          this.currentQuestionIndex != null &&
          this.currentQuestionIndex! < this.questions.length
      ? this.questions[this.currentQuestionIndex ?? 0]
      : KQuestion();

  List<KAnswer> get currentQuestionAnswers =>
      this.currentQuestion.generateAnswers(4, answerType ?? 'number');

  bool get canRestartGame =>
      (currentLevel ?? 0) + 1 < levelHardness.length ||
      ((currentLevel ?? 0) < levelHardness.length &&
          questions.length > 0 &&
          ((rightAnswerCount ?? 0) / questions.length) <
              levelHardness[currentLevel ?? 0]);

  KGameData({
    required this.gameID,
    this.gameAppID,
    this.gameName,
    this.levelCount = 1,
    this.currentLevel = 0,
    this.game,
    this.score,
    this.isSpeechGame = false,
    this.baseLevelHardness = 0.7,
    this.currentQuestionIndex = 0,
    this.answerType = "number",
    this.isCountTime = false,
  });
}
