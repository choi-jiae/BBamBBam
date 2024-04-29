import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String hintText;
  final int maxSize;
  final String errorMessage;
  final TextEditingController controller;

  EditText({
    Key? key,
    required this.label,
    required this.obscureText,
    required this.keyboardType,
    required this.textInputAction,
    required this.hintText,
    required this.maxSize,
    required this.errorMessage,
    required this.controller,
  }) : super(key: key);

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  // late TextEditingController _controller;
  //     TextEditingController(text: widget.value);
  bool _isEditable = false;

  // @override
  // void initState() {
  //   super.initState();
  //   // _controller = TextEditingController(text: widget.value);
  //   ; // 여기에서 컨트롤러를 초기화
  // }

  // @override
  // void dispose() {
  //   _controller.dispose(); // 위젯이 소멸될 때 컨트롤러를 정리
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          Expanded(
            flex: 3,
            child: Center(child: Text(widget.label)),
          ),
          Expanded(
              flex: 5,
              child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  enabled: _isEditable, // 사용 가능한 상태로 설정
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    // suffixIcon: IconButton(
                    //   icon: Icon(Icons.edit),
                    //   onPressed: () {
                    //     setState(() {
                    //       _isEditable = true;
                    //     });
                    //   },
                    // ),
                  ),
                  validator: (value) {
                    if (value != null && value.length < widget.maxSize) {
                      return widget.errorMessage;
                    }
                    return null;
                  })),
          Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditable = !_isEditable;
                  });
                },
              ))
        ]));
  }
}
