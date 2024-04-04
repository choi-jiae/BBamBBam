import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  bool _isCheckT = false;
  Future<void> _submit() async {
    if (formKey.currentState!.validate() == false) {
      return;
    } else {
      formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("가입이 완료되었습니다. 로그인을 진행해주세요."),
        duration: Duration(seconds: 1),
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              '회원가입',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue),
        body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                          child: Icon(
                        Icons.account_circle,
                        size: MediaQuery.of(context).size.width / 4,
                      ))),
                  TextFormFieldComponent(
                      context,
                      "이름",
                      false,
                      TextInputType.text,
                      TextInputAction.next,
                      "Username",
                      4,
                      "Username is too short"),
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
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("개인 정보 수집 동의(필수)"),
                            Checkbox(
                              value: _isCheckT,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    _isCheckT = value;
                                  });
                                }
                              },
                              activeColor: Colors.blue,
                            ),
                          ])),
                  TextButton(
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: Text(
                            "가입하기",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )),
                      onPressed: () {
                        _submit();
                      }),
                ],
              ),
            )));
  }
}

Widget TextFormFieldComponent(
    BuildContext context,
    String label,
    bool obscureText,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    String hintText,
    int maxSize,
    String errorMessage) {
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

// Container(
//                         height: 40,
//                         width: double.infinity,
//                         alignment: Alignment.center,
//                         de
//                       )
