import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HangulWebKeyboardSetting extends StatefulWidget {
  final TextEditingController controller;
  final Widget child;

  const HangulWebKeyboardSetting({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  _HangulWebKeyboardSettingState createState() =>
      _HangulWebKeyboardSettingState();
}

class _HangulWebKeyboardSettingState extends State<HangulWebKeyboardSetting> {
  final FocusNode _focusNode = FocusNode();

  // Ensure this list is defined within the class to be accessible in the handleKeyPress method
  static const List<String> undetected_list = [
    " ",
    "`",
    "~",
    "!",
    "@",
    "#",
    "\$",
    "%",
    "^",
    "&",
    "*",
    "(",
    ")",
    "-",
    "_",
    "=",
    "+",
    "[",
    "]",
    "{",
    "}",
    "'",
    '"',
    ";",
    ":",
    "/",
    "?",
    ",",
    ".",
    "<",
    ">",
    "\\",
    "|",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0"
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          handleKeyPress(event);
        }
        // return KeyEventResult.ignored; // Correct return type
      },
      autofocus: true,
      child: widget.child,
    );
  }

  void handleKeyPress(KeyDownEvent event) {
    String keyLabel = event.logicalKey.keyLabel;
    int cursorPosition = widget.controller.selection.baseOffset;

    if (undetected_list.contains(keyLabel)) {
      List<String> textList = widget.controller.text.split('');
      textList.insert(cursorPosition, keyLabel);
      widget.controller.text = textList.join();
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + 1),
      );
    }
  }
}
