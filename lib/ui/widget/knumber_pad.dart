import 'package:app_core/value/kstyles.dart';
import 'package:flutter/material.dart';

enum KNumberPadMode { NONE, NUMBER, QWERTY }
enum KNumberPadStyle { ORIGINAL, CASHAPP }

class _NumpadStyleManager extends InheritedWidget {
  final KNumberPadStyle style;

  const _NumpadStyleManager({
    required Widget child,
    required this.style,
  }) : super(child: child);

  static _NumpadStyleManager of(BuildContext context) {
    final _NumpadStyleManager? result =
        context.dependOnInheritedWidgetOfExactType<_NumpadStyleManager>();
    assert(result != null, 'No _NumpadStyleManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_NumpadStyleManager old) => this.style != old.style;
}

class KNumberPad extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onReturn;
  final void Function(String)? onTextChange;
  final KNumberPadStyle style;
  final int decimals;

  KNumberPad({
    required this.controller,
    required this.onReturn,
    this.onTextChange,
    this.style = KNumberPadStyle.ORIGINAL,
    this.decimals = 2,
  });

  void _qwertyHandler() => this.onReturn.call();

  void _textChange(String string) => this.onTextChange?.call(string);

  double _getShortestSide() => WidgetsBinding.instance != null
      ? MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
          .size
          .shortestSide
      : 200;

  double _keyboardHeight() {
    final w = _getShortestSide();
    // print("shortestSide $w");
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
    return _NumpadStyleManager(
      style: style,
      child: Container(
        height: _keyboardHeight(),
        width: _getShortestSide() > 600 ? 600 : _getShortestSide(),
        color: Colors.transparent,
        child: Column(
          children: [
            buildRowOne(),
            buildRowTwo(),
            buildRowThree(),
            buildRowFour(),
          ],
        ),
      ),
    );
  }

  void _insertText(String myText) {
    // print("INSERT TEXT");

    if (style == KNumberPadStyle.ORIGINAL) {
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
    } else {
      //CASHAPP
      if (controller.text.contains('.') && myText == '.') {
        return;
      } else if (controller.text.contains('.') &&
          controller.text.replaceAll(RegExp(r"[0-9]*\."), "").length >=
              decimals) {
        return;
      }
      controller.text += myText;
    }
  }

  void _backspace() {
    // print("BACKSPACE");

    if (style == KNumberPadStyle.ORIGINAL) {
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
    } else {
      //CASHAPP
      if (controller.text.length > 1) {
        // print("TEXT LENGTH > 1");
        final newString =
            controller.text.substring(0, controller.text.length - 1);
        controller.text = newString;
      } else if (controller.text == 1) {
        // print("TEXT LENGTH == 0");
        controller.text = "0";
      } else {
        // print("TEXT LENGTH IS <= 0");
      }
    }
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  Expanded buildRowOne() {
    if (style == KNumberPadStyle.ORIGINAL) {
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
    } else {
      // CASHAPP
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
          ],
        ),
      );
    }
  }

  Expanded buildRowTwo() {
    if (style == KNumberPadStyle.ORIGINAL) {
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
    } else {
      // CASHAPP
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
          ],
        ),
      );
    }
  }

  Expanded buildRowThree() {
    if (style == KNumberPadStyle.ORIGINAL) {
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
    } else {
      //CASHAPP
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
          ],
        ),
      );
    }
  }

  Expanded buildRowFour() {
    if (style == KNumberPadStyle.ORIGINAL) {
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
    } else {
      //CASHAPP
      final decimalButton = decimals > 0
          ? _TextKey(text: '.', onTextInput: _insertText)
          : _TextKey(text: '', onTextInput: null);
      return Expanded(
        child: Row(
          children: [
            decimalButton,
            _TextKey(
              text: '0',
              onTextInput: _insertText,
            ),
            _BackspaceKey(onBackspace: _backspace),
          ],
        ),
      );
    }
  }
}

class _TextKey extends StatelessWidget {
  final String text;
  final ValueSetter<String>? onTextInput;
  final int flex;

  const _TextKey({
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theText;
    if (_NumpadStyleManager.of(context).style == KNumberPadStyle.ORIGINAL) {
      theText = Text(
        this.text,
        style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
      );
    } else {
      theText = Text(
        this.text,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      );
    }

    return Expanded(
      flex: flex,
      child: _BaseKey(
        onClick: () => this.onTextInput?.call(this.text),
        child: theText,
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
    final theIcon;
    if (_NumpadStyleManager.of(context).style == KNumberPadStyle.ORIGINAL) {
      theIcon = Icon(
        Icons.backspace_outlined,
        color: Theme.of(context).accentColor,
      );
    } else {
      theIcon = Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).primaryColor,
        size: 20,
      );
    }

    return Expanded(
      flex: flex,
      child: _BaseKey(
        onClick: this.onBackspace,
        child: theIcon,
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

  const _SmallTextKey({
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  });

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
  final Widget child;
  final VoidCallback? onClick;

  const _BaseKey({required this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final body;
    if (_NumpadStyleManager.of(context).style == KNumberPadStyle.ORIGINAL) {
      final content = Container(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: KStyles.colorDivider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: this.child),
      );

      body = Material(
        // color: Colors.white,
        child: onClick == null
            ? content
            : InkWell(
                onTap: this.onClick,
                child: content,
              ),
      );
    } else {
      body = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onClick,
          child: Center(child: child),
        ),
      );
    }

    return body;
  }
}
