import 'dart:io';

import 'package:bbambbam/pages/home/sidetap/sidetap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  File? _image;
  // String imageUrl = "gs://bbambbam-a937f.appspot.com/userimage/pubao.jpg";
  String? imageUrl;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();

  bool _isCheckT = false;
  Future<void> _submit() async {
    if (formKey.currentState!.validate() == false) {
      return;
    } else {
      formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          title: const Text(
            '회원가입',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        // drawer: Sidetap(),
        body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Center(
                      child: GestureDetector(
                        onTap: getImage, //누르면 이동
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 4,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          // backgroundColor: Colors.blue,
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child:
                                  Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextFormFieldComponent(
                      context,
                      _emailController,
                      "이메일",
                      false,
                      TextInputType.emailAddress,
                      TextInputAction.next,
                      "Email",
                      8,
                      "정확한 이메일 계정을 입력해주세요"),
                  TextFormFieldComponent(
                      context,
                      _nameController,
                      "닉네임",
                      false,
                      TextInputType.text,
                      TextInputAction.next,
                      "Username",
                      2,
                      "2글자 이상의 닉네임으로 설정해주세요"),
                  TextFormFieldComponent2(
                      context,
                      _pwController,
                      _pwConfirmController,
                      "비밀번호",
                      true,
                      TextInputType.text,
                      TextInputAction.next,
                      "Password",
                      8,
                      "8글자 이상의 비밀번호로 설정해주세요"),
                  const SizedBox(height: 15),
                  Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("개인 정보 수집 동의(필수)"),
                            Checkbox(
                              value: _isCheckT,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    _isCheckT = value;
                                  });
                                }
                              },
                              activeColor: Colors.blueAccent,
                            ),
                          ])),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: submitButton(),
                    ),
                  )
                ],
              ),
            )));
  }

  Future getImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery); //이미지 선택 기다리기
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); //이미지 파일로 설정
      });
    }
  }

  Future uploadImageToFirebase(String uid) async {
    // if (_image == null) {
    //   //image가 없으면 return
    //   return "";
    // }
    // DateTime.now().millisecondsSinceEpoch
    String fileName = 'userimage/$uid.jpg';
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      if (_image == null) {
        fileName = 'userimage/pubao.jpg';
        imageUrl = await storage.ref(fileName).getDownloadURL();
      } else {
        await storage.ref(fileName).putFile(_image!);
        imageUrl = await storage.ref(fileName).getDownloadURL();
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (!_isCheckT) {
          // 체크박스가 선택되지 않았을 경우 경고 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('개인 정보 수집에 동의해주세요.'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (formKey.currentState!.validate()) {
          try {
            final credential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _pwController.text,
            )
                .then((credential) async {
              final user = credential.user;
              if (user != null) {
                String uid = user.uid;

                await uploadImageToFirebase(uid);

                imageUrl ??=
                    "gs://bbambbam-a937f.appspot.com/userimage/pubao.jpg";

                FirebaseFirestore.instance.collection('User').doc(uid).set({
                  'Email': _emailController.text,
                  'Name': _nameController.text,
                  "UserImage": imageUrl,
                });
              } else {
                debugPrint("Failed to create user.");
              }

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("가입이 완료되었습니다. 로그인을 진행해주세요."),
                duration:
                    Duration(seconds: 2), // 시간을 조금 더 주어 사용자가 메시지를 볼 시간을 확보
              ));

              // SnackBar 표시 후에 화면 전환을 위해 Future.delayed를 사용합니다.
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(); // SnackBar가 사라진 후 이전 화면으로 돌아갑니다.
              });
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              debugPrint('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              debugPrint('The account already exists for that email');
            }
          } catch (e) {
            print(e.toString());
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent),
      ),
      child: const Text("가입하기",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          )),
    );
  }
}

Widget TextFormFieldComponent(
    BuildContext context,
    TextEditingController controller,
    String label,
    bool obscureText,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    String hintText,
    int maxSize,
    String errorMessage) {
  return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Center(child: Text(label)),
        ),
        Expanded(
            flex: 3,
            child: TextFormField(
                controller: controller,
                autofocus: true,
                obscureText: obscureText,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(), // 입력 필드에 테두리 추가
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10), // 입력 필드 내부 패딩 조정
                ),
                validator: (value) {
                  if (value!.length < maxSize) {
                    return errorMessage;
                  }
                  return null;
                }))
      ]));
}

Widget TextFormFieldComponent2(
    BuildContext context,
    TextEditingController pwController,
    TextEditingController pwConfirmController,
    String label,
    bool obscureText,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    String hintText,
    int maxSize,
    String errorMessage) {
  return Column(children: [
    Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          Expanded(
            flex: 3,
            child: Center(child: Text(label)),
          ),
          Expanded(
              flex: 3,
              child: TextFormField(
                  controller: pwController,
                  autofocus: true,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: const OutlineInputBorder(), // 입력 필드에 테두리 추가
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10), // 입력 필드 내부 패딩 조정
                  ),
                  validator: (value) {
                    if (value!.length < maxSize) {
                      return errorMessage;
                    }
                    return null;
                  }))
        ])),
    Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          const Expanded(
            flex: 3,
            child: Center(child: Text("비밀번호 확인")),
          ),
          Expanded(
              flex: 3,
              child: TextFormField(
                  controller: pwConfirmController,
                  autofocus: true,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: const OutlineInputBorder(), // 입력 필드에 테두리 추가
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10), // 입력 필드 내부 패딩 조정
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value != pwController.text) {
                      return "비밀번호가 일치하지 않습니다.";
                    }
                    return null;
                  }))
        ])),
  ]);
}
