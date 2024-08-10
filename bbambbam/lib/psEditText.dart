import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PSEditText extends StatefulWidget {
  final String label;
  final String field;
  final bool editable;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String hintText;
  final int maxSize;
  final String errorMessage;
  final TextEditingController controller;

  const PSEditText({
    super.key,
    required this.label,
    required this.field,
    required this.editable,
    required this.obscureText,
    required this.keyboardType,
    required this.textInputAction,
    required this.hintText,
    required this.maxSize,
    required this.errorMessage,
    required this.controller,
  });

  @override
  State<PSEditText> createState() => _EditTextState();
}

class _EditTextState extends State<PSEditText> {
  bool _isEditable = false;
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _checkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Row(children: [
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
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      if (widget.editable == true) {
                        _isEditable = true;
                      }
                    });
                  },
                ))
          ]),
          if (_isEditable)
            Column(children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Center(child: Text("현재 비밀번호")),
                      ),
                      Expanded(
                          flex: 6,
                          child: TextFormField(
                              controller: _currentController,
                              obscureText: widget.obscureText,
                              keyboardType: widget.keyboardType,
                              textInputAction: widget.textInputAction,
                              enabled: _isEditable, // 사용 가능한 상태로 설정
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                              ),
                              validator: (value) {
                                if (value != null &&
                                    value.length < widget.maxSize) {
                                  return widget.errorMessage;
                                }
                                return null;
                              })),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Center(child: Text("새 비밀번호")),
                      ),
                      Expanded(
                          flex: 6,
                          child: TextFormField(
                              controller: _newController,
                              obscureText: widget.obscureText,
                              keyboardType: widget.keyboardType,
                              textInputAction: widget.textInputAction,
                              enabled: _isEditable, // 사용 가능한 상태로 설정
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                              ),
                              validator: (value) {
                                if (value != null &&
                                    value.length < widget.maxSize) {
                                  return widget.errorMessage;
                                }
                                return null;
                              })),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Center(child: Text("새 비밀번호 확인")),
                      ),
                      Expanded(
                          flex: 6,
                          child: TextFormField(
                              controller: _checkController,
                              obscureText: widget.obscureText,
                              keyboardType: widget.keyboardType,
                              textInputAction: widget.textInputAction,
                              enabled: _isEditable, // 사용 가능한 상태로 설정
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                              ),
                              validator: (value) {
                                if (value != null &&
                                    value.length < widget.maxSize) {
                                  return widget.errorMessage;
                                }
                                return null;
                              })),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0), // 모든 방향으로 16.0의 패딩 추가
                child: TextButton(
                  onPressed: () {
                    _pwcheck();
                  },
                  child: const Text(
                    "수정하기",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0, // 글씨 크기를 18.0으로 설정
                    ),
                  ),
                ),
              ),
            ])
        ]));
  }

  _pwcheck() async {
    String curPW = _currentController.text;
    String newPW = _newController.text;
    String newPWCheck = _checkController.text;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String email = user!.email!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: curPW);

    try {
      UserCredential result =
          await user.reauthenticateWithCredential(credential);
      print('재로그인 성공!');

      try {
        if (newPW != newPWCheck) {
          checkDialog("새 비밀번호가 일치하지 않습니다.");
        } else {
          await result.user!.updatePassword(newPW);
          print('비밀번호 변경 완료');
          setState(() {
            if (widget.editable == true) {
              _isEditable = false;
            }
          });
          checkDialog("비밀번호 변경이 완료되었습니다.");
        }
      } catch (updateError) {
        print('새 비밀번호 설정 실패');
        checkDialog("새 비밀번호로 변경할 수 없습니다.");
      }
    } catch (error) {
      checkDialog("현재 비밀번호가 일치하지 않습니다.");
    }
  }

  Future<dynamic> checkDialog(String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("비밀번호 확인"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  }),
            ],
          );
        });
  }
}
