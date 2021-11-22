import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KNumberPad extends StatelessWidget {
  static const int KEYBOARD_MODE_NONE = 0;
  static const int KEYBOARD_MODE_NUMBER = 1;
  static const int KEYBOARD_MODE_QUERY = 2;

  final TextEditingController controller;
  final VoidCallback onReturn;
  final void Function(String) onTextChange;

  KNumberPad({
    required this.controller,
    required this.onReturn,
    required this.onTextChange,
  });

  void _qwertyHandler() => this.onReturn.call();

  void _textChange(String string) => this.onTextChange.call(string);

  double _getShortestSide() => WidgetsBinding.instance != null
      ? MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
          .size
          .shortestSide
      : 200;

  double _keyboardHeight() {
    double w = _getShortestSide();
    print("shortestSide $w");
    if (w > 375) {
      return 250;
    } else if (w > 320) {
      return 200; // iphone 6,7,8, plus 375
    } else {
      return 200; // iphone 5se 320
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _keyboardHeight(),
      width: _getShortestSide() > 600 ? 600 : _getShortestSide(),
      color: Colors.white,
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
          buildRowFour(),
        ],
      ),
    );
  }

  void _insertText(String myText) {
    final text = controller.text;
    final textSelection = controller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    controller.text = newText;
    _textChange(newText);
    controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = controller.text;
    final textSelection = controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      controller.text = newText;
      _textChange(newText);
      controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    } else {}

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    controller.text = newText;
    controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
    _textChange(newText);
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          _TextKey(
            text: '1',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '2',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '3',
            onTextInput: _insertText,
          ),
          _BackspaceKey(
            onBackspace: () => _backspace(),
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          _TextKey(
            text: '4',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '5',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '6',
            onTextInput: _insertText,
          ),
          _SmallTextKey(
            text: '-',
            onTextInput: _insertText,
          ),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          _TextKey(
            text: '7',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '8',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '9',
            onTextInput: _insertText,
          ),
          _SmallTextKey(
            text: '#',
            onTextInput: _insertText,
          ),
        ],
      ),
    );
  }

  Expanded buildRowFour() {
    return Expanded(
      child: Row(
        children: [
          _TextKey(
            text: '+',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '0',
            onTextInput: _insertText,
          ),
          _TextKey(
            text: '.',
            onTextInput: _insertText,
          ),
          _QwertyKey(
            onQwerty: _qwertyHandler,
          )
        ],
      ),
    );
  }
}

class _TextKey extends StatelessWidget {
  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  const _TextKey(
      {required this.text, required this.onTextInput, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: _BaseKey(
        onClick: () => this.onTextInput.call(this.text),
        child: Text(
          this.text,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  final VoidCallback onBackspace;
  final int flex;

  const _BackspaceKey({required this.onBackspace, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: _BaseKey(
        onClick: this.onBackspace,
        child: Icon(Icons.backspace_outlined,
            color: Theme.of(context).accentColor),
      ),
    );
  }
}

class _QwertyKey extends StatelessWidget {
  final VoidCallback onQwerty;
  final int flex;

  const _QwertyKey({required this.onQwerty, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: _BaseKey(
        onClick: this.onQwerty,
        child: Icon(Icons.check, color: Theme.of(context).accentColor),
      ),
    );
  }
}

class _SmallTextKey extends StatelessWidget {
  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  const _SmallTextKey(
      {required this.text, required this.onTextInput, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: _SmallBaseKey(
        onClick: () => this.onTextInput.call(this.text),
        child: Text(
          this.text,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class _SmallBaseKey extends StatelessWidget {
  final VoidCallback onClick;
  final Widget child;

  const _SmallBaseKey({required this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: KStyles.colorDivider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: this.child),
    );

    final body = Material(
      // color: Colors.white,
      child: InkWell(
        onTap: this.onClick,
        child: content,
      ),
    );

    return body;
  }
}

class _BaseKey extends StatelessWidget {
  final VoidCallback onClick;
  final Widget child;

  const _BaseKey({required this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: KStyles.colorDivider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: this.child),
    );

    final body = Material(
      // color: Colors.white,
      child: InkWell(
        onTap: this.onClick,
        child: content,
      ),
    );

    return body;
  }
}
