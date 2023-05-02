import 'dart:convert';

import 'package:app_core/helper/ktts_helper.dart';
import 'package:app_core/model/kanswer.dart';
import 'package:app_core/model/kquestion.dart';
import 'package:app_core/model/study_problem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_core/app_core.dart';

class SelfStudyView extends StatefulWidget {
  @override
  _SelfStudyViewState createState() => _SelfStudyViewState();
}

class _SelfStudyViewState extends State<SelfStudyView> {
  List<KQuestion>? _questions;
  int? _questionIndex;

  List<KAnswer> _randomizedChoices = [];
  Set<KAnswer> _incorrectChoices = {};

  bool get isTtsEnabled => true;

  KQuestion? get currentQuestion => _questions == null ||
          ((_questionIndex ?? -1) >= (_questions?.length ?? 0) ||
              (_questionIndex ?? -1) < 0)
      ? null
      : _questions![_questionIndex ?? 0];

  @override
  void initState() {
    super.initState();
    if (_questions == null) loadProblems();
  }

  void loadProblems() async {
    final raw = await rootBundle.loadString(KAssets.JSON_SELF_STUDY_BEGINNER);

    final List<KQuestion> data = (json.decode(raw) as List)
        .map((i) => StudyProblem.fromJson(i))
        .map((sp) {
      final ans1 = KAnswer()
        ..answerID = sp.choice1
        ..text = sp.choice1
        ..correctAnswer = sp.answer
        ..isCorrect = sp.choice1 == sp.answer;
      final ans2 = KAnswer()
        ..answerID = sp.choice2
        ..text = sp.choice2
        ..correctAnswer = sp.answer
        ..isCorrect = sp.choice2 == sp.answer;
      final ans3 = KAnswer()
        ..answerID = sp.choice3
        ..text = sp.choice3
        ..correctAnswer = sp.answer
        ..isCorrect = sp.choice3 == sp.answer;
      final ans4 = KAnswer()
        ..answerID = sp.choice4
        ..text = sp.choice4
        ..correctAnswer = sp.answer
        ..isCorrect = sp.choice4 == sp.answer;
      final question = KQuestion()
        ..text = sp.promptText
        ..mediaType = KQuestion.MEDIA_TYPE_TEXT
        ..mediaURL = sp.promptImage
        ..answers = ([ans1, ans2, ans3, ans4]..shuffle());
      return question;
    }).toList();
    _questions = data;

    setupProblem(0);
  }

  void setupProblem(int index) {
    if (!mounted) return;

    setState(() {
      _questionIndex = index;
      if (this.currentQuestion != null)
        this._randomizedChoices = this.currentQuestion!.answers ?? [];
      this._incorrectChoices = {};
    });
    print("PROBLEM - " + KUtil.prettyJSON(this.currentQuestion));
  }

  void onAnswerClick(KAnswer answer) async =>
      (answer == this.currentQuestion?.correctAnswer
              ? onAnswerCorrect
              : onAnswerFail)
          .call(answer);

  void onAnswerCorrect(KAnswer choice) {
    print("choice: $choice");
    setupProblem((this._questionIndex ?? 0) + 1);
  }

  void onAnswerFail(KAnswer choice) =>
      setState(() => this._incorrectChoices.add(choice));

  @override
  Widget build(BuildContext context) {
    final quizView = currentQuestion == null
        ? Container()
        : _Quiz(
            currentQuestion: currentQuestion!,
            randomizedChoices: _randomizedChoices,
            onAnswerClick: onAnswerClick,
            isTtsEnabled: isTtsEnabled,
            incorrectChoices: _incorrectChoices,
          );

    final body = this._questions == null
        ? Container()
        : this._questions!.isEmpty
            ? Center(child: Text("Nothing to study yet"))
            : quizView;

    return body;
  }
}

class _Quiz extends StatelessWidget {
  final KQuestion currentQuestion;
  final List<KAnswer> randomizedChoices;
  final Function(KAnswer) onAnswerClick;
  final bool isTtsEnabled;
  final Set<KAnswer> incorrectChoices;

  const _Quiz({
    Key? key,
    required this.currentQuestion,
    required this.randomizedChoices,
    required this.onAnswerClick,
    required this.isTtsEnabled,
    required this.incorrectChoices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prompt = _PromptView(
      this.currentQuestion,
      isTtsEnabled: isTtsEnabled,
    );

    final choices = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: this.randomizedChoices.length >= 2
              ? [
                  _ChoiceButton(
                    this.randomizedChoices[0],
                    onClick: onAnswerClick,
                    isTtsEnabled: this.isTtsEnabled,
                    attemptedChoices: this.incorrectChoices,
                  ),
                  _ChoiceButton(
                    this.randomizedChoices[1],
                    onClick: onAnswerClick,
                    isTtsEnabled: this.isTtsEnabled,
                    attemptedChoices: this.incorrectChoices,
                  ),
                ]
              : [],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: this.randomizedChoices.length >= 4
              ? [
                  _ChoiceButton(
                    this.randomizedChoices[2],
                    onClick: onAnswerClick,
                    isTtsEnabled: this.isTtsEnabled,
                    attemptedChoices: this.incorrectChoices,
                  ),
                  _ChoiceButton(
                    this.randomizedChoices[3],
                    onClick: onAnswerClick,
                    isTtsEnabled: this.isTtsEnabled,
                    attemptedChoices: this.incorrectChoices,
                  ),
                ]
              : [],
        ),
      ],
    );

    final body = Column(
      children: [
        Expanded(child: Center(child: prompt)),
        Expanded(child: choices),
      ],
    );

    return body;
  }
}

class _ChoiceButton extends StatelessWidget {
  final KAnswer answer;
  final Function(KAnswer) onClick;
  final bool isTtsEnabled;
  final Set<KAnswer> attemptedChoices;

  bool get isCorrect =>
      this.attemptedChoices.contains(this.answer) &&
      (this.answer.isCorrect ?? false);

  bool get isWrong =>
      this.attemptedChoices.contains(this.answer) &&
      !(this.answer.isCorrect ?? false);

  const _ChoiceButton(
    this.answer, {
    required this.onClick,
    required this.isTtsEnabled,
    required this.attemptedChoices,
  });

  void onAudioClick() => KTTSHelper.speak(this.answer.text ?? "");

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Center(
          child: Text(
            this.answer.text ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: this.isCorrect || this.isWrong
                    ? Colors.white
                    : Theme.of(context).primaryColor),
          ),
        ),
        if (this.isTtsEnabled)
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: onAudioClick,
              child: Icon(
                Icons.volume_up_rounded,
                color: this.isCorrect || this.isWrong
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
          ),
      ],
    );

    return Container(
      width: 140,
      height: 100,
      child: ElevatedButton(
        onPressed: () => this.onClick(this.answer),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: this.isWrong
              ? Colors.red
              : this.isCorrect
                  ? Colors.green
                  : Theme.of(context).colorScheme.background,
          padding: EdgeInsets.all(6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: KStyles.grey),
          ),
        ),
        child: body,
      ),
    );
  }
}

class _PromptView extends StatelessWidget {
  final KQuestion question;
  final bool isTtsEnabled;

  const _PromptView(this.question, {this.isTtsEnabled = true});

  @override
  Widget build(BuildContext context) {
    final prompt;
    switch (this.question.mediaType) {
      case KQuestion.MEDIA_TYPE_TEXT:
        prompt = GestureDetector(
          onTap: () => KTTSHelper.speak(
            this.question.text!,
            language: KTTSHelper.ENGLISH,
          ),
          child: Text(
            this.question.text ?? "",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
        break;
      case KQuestion.MEDIA_TYPE_IMAGE:
        prompt = GestureDetector(
          onTap: () => KTTSHelper.speak(
            this.question.text!,
            language: KTTSHelper.ENGLISH,
          ),
          child: FadeInImage.assetNetwork(
            placeholder: KAssets.IMG_TRANSPARENCY,
            image: this.question.mediaURL!,
            fadeInDuration: Duration(milliseconds: 100),
          ),
        );
        break;
      default:
        prompt = Container();
        break;
    }

    final ttsButton = GestureDetector(
      onTap: () => KTTSHelper.speak(
        this.question.text!,
        language: KTTSHelper.ENGLISH,
      ),
      child: Icon(Icons.volume_up_rounded, size: 32),
    );

    final body = Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: prompt),
          if (this.isTtsEnabled && this.question.text != null) ...[
            SizedBox(height: 20),
            ttsButton,
          ],
        ],
      ),
    );

    return body;
  }
}
