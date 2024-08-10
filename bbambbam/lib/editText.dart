import 'package:bbambbam/providers/user_info_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditText extends StatefulWidget {
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

  const EditText({
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
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool _isEditable = false;

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
              child: widget.editable
                  ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditable = true;
                        });
                      },
                    )
                  : Container(),
            )
          ]),
          if (_isEditable)
            Padding(
              padding: const EdgeInsets.all(16.0), // 모든 방향으로 16.0의 패딩 추가
              child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // String uid = FirebaseAuth.instance.currentUser!.uid;
                        // FirebaseFirestore.instance
                        //     .collection("User")
                        //     .doc(uid)
                        //     .update({widget.field: widget.controller.text});
                        final userInfoProvider = Provider.of<UserInfoProvider>(
                            context,
                            listen: false);

                        // Firestore 업데이트 및 상태 관리
                        String newValue = widget.controller.text;
                        userInfoProvider.updateUserInfo(widget.field, newValue);

                        return AlertDialog(
                          title: const Text("수정 확인"),
                          content: Text("${widget.label} 변경이 완료되었습니다."),
                          actions: <Widget>[
                            TextButton(
                                child: const Text("확인"),
                                onPressed: () {
                                  Navigator.of(context).pop(); // 다이얼로그 닫기
                                  setState(() {
                                    _isEditable = false;
                                  });
                                }),
                            // TextButton(
                            //     child: Text("취소"),
                            //     onPressed: () {
                            //       Navigator.of(context).pop(); // 다이얼로그 닫기
                            //     })
                          ],
                        );
                      });
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
        ]));
  }
}
