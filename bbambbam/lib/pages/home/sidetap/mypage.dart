import 'package:bbambbam/editText.dart';
import 'package:bbambbam/pages/auth/login.dart';
import 'package:bbambbam/providers/user_info_provider.dart';
import 'package:bbambbam/psEditText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: true);
    final userInfo = userInfoProvider.userInfo;

    final TextEditingController emailController =
        TextEditingController(text: userInfo?['Email']);
    final TextEditingController nicknameController =
        TextEditingController(text: userInfo?['Name']);
    final TextEditingController passwordController =
        TextEditingController(text: "123456789");
    final TextEditingController confirmPasswordController =
        TextEditingController(text: "123456789");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          Image.network(userInfo?['UserImage']).image,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userInfo?['Name'],
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
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
                      controller: emailController,
                    ),
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
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("탈퇴 확인"),
                              content: const Text("정말로 탈퇴하겠습니까?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("확인"),
                                  onPressed: () {
                                    _withdrawal();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("취소"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        "회원 탈퇴",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteUserStore(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('User').doc(uid).delete();
    } catch (e) {
      print("Error deleting user data from Firestore: $e");
    }
  }

  Future<void> _deleteUserAuth() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      await currentUser?.delete();
    } catch (e) {
      print("Error deleting user from Firebase Auth: $e");
    }
  }

  Future<void> _withdrawal() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _deleteUserStore(uid);
        await _deleteUserAuth();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("탈퇴 확인"),
              content: const Text("탈퇴가 완료되었습니다."),
              actions: <Widget>[
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    Navigator.of(context).pushNamed("/login");
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
