import 'package:bbambbam/editText.dart';
import 'package:bbambbam/psEditText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  final formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  getUserInfo() async {
    var result =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
    return result.data();
  }

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
        body: FutureBuilder(
            future: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final TextEditingController emailController =
                    TextEditingController(
                        text: (snapshot.data as Map)['Email']);
                final TextEditingController nicknameController =
                    TextEditingController(text: (snapshot.data as Map)['Name']);
                final TextEditingController passwordController =
                    TextEditingController(text: "123456789");
                final TextEditingController confirmPasswordController =
                    TextEditingController(text: "123456789");

                return snapshot.hasData
                    ? Form(
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
                                  backgroundImage:
                                      AssetImage('assets/image/pubao.jpg'),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  (snapshot.data as Map)['Name'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
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
                                SizedBox(height: 20),
                                EditText(
                                    label: '이메일',
                                    field: 'Email',
                                    editable: false,
                                    obscureText: false,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    hintText: 'Enter your email',
                                    maxSize: 20,
                                    errorMessage: 'Email is too short',
                                    // value: "limgm123@naver.com",
                                    controller: emailController),
                                EditText(
                                  label: '닉네임',
                                  field: 'Name',
                                  editable: true,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  hintText: 'Enter your nickname',
                                  maxSize: 8,
                                  errorMessage: 'ID is too short',
                                  // value: "푸바오"
                                  controller: nicknameController,
                                ),
                                PSEditText(
                                  label: '비밀번호',
                                  field: 'PW',
                                  editable: true,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  hintText: 'Enter your password',
                                  maxSize: 8,
                                  errorMessage: 'Password is too short',
                                  // value: "1234"
                                  controller: passwordController,
                                ),
                                SizedBox(height: 20),
                                // Padding(
                                //   padding: EdgeInsets.all(16),
                                //   child: TextButton(
                                //       child: Container(
                                //           height: 40,
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width /
                                //               2,
                                //           alignment: Alignment.center,
                                //           decoration: BoxDecoration(
                                //             borderRadius:
                                //                 BorderRadius.circular(20),
                                //             color: Colors.blue,
                                //           ),
                                //           child: Text(
                                //             "변경하기",
                                //             style: TextStyle(
                                //               fontWeight: FontWeight.bold,
                                //               fontSize: 20,
                                //               color: Colors.white,
                                //             ),
                                //             textAlign: TextAlign.center,
                                //           )),
                                //       onPressed: () {
                                //         String email = emailController.text;
                                //         String nickname =
                                //             nicknameController.text;
                                //         String password =
                                //             passwordController.text;
                                //         String confirmPassword =
                                //             confirmPasswordController.text;

                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text("탈퇴 확인"),
                                                content: Text("정말로 탈퇴하겠습니까?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                      child: Text("확인"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  TextButton(
                                                      child: Text("취소"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      })
                                                ]);
                                          });
                                    },
                                    child: Text(
                                      "회원 탈퇴",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ),
                          )
                        ])))
                    : Center(child: CircularProgressIndicator());
              }
            }));
  }
}

//데이터 유효성 검사, 이메일, 닉네임, 비밀번호 **id는 변경 불가!!
//탈퇴하기 기능 구현