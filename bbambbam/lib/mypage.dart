import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '마이페이지',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                // color: Colors.blue[200],
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/image/pubao.jpg'),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "푸바오",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    TextFormFieldComponent(
                        context,
                        "이메일",
                        false,
                        TextInputType.emailAddress,
                        TextInputAction.next,
                        "Email",
                        8,
                        "Email is too short"),
                    TextFormFieldComponent(
                        context,
                        "아이디",
                        false,
                        TextInputType.text,
                        TextInputAction.next,
                        "ID",
                        4,
                        "ID is too short"),
                    TextFormFieldComponent(
                        context,
                        "비밀번호",
                        true,
                        TextInputType.text,
                        TextInputAction.next,
                        "Password",
                        8,
                        "Password is too short"),
                    TextFormFieldComponent(
                        context,
                        "비밀번호 확인",
                        true,
                        TextInputType.text,
                        TextInputAction.done,
                        "Confirm Password",
                        8,
                        "Password confirmation is too short"),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: TextButton(
                          child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue,
                              ),
                              child: Text(
                                "변경하기",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () {}),
                    )
                  ],
                ),
              )
            ]))));
  }
}

//마이페이지 수정 기능 구현 & 수정 시에만 비활성화 & 탈퇴하기 기능 구현
Widget TextFormFieldComponent(
    BuildContext context,
    String label,
    bool obscureText,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    String hintText,
    int maxSize,
    String errorMessage) {
  bool _isEditable = false;

  return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Center(child: Text(label)),
        ),
        Expanded(
            flex: 3,
            child: TextFormField(
                obscureText: obscureText,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(), // 입력 필드에 테두리 추가
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10), // 입력 필드 내부 패딩 조정
                ),
                validator: (value) {
                  if (value!.length < maxSize) {
                    return errorMessage;
                  }
                }))
      ]));
}
