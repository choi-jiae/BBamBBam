import 'package:bbambbam/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbambbam/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color.fromARGB(255, 248, 249, 250),
            child: Center(
                child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 300,
                          height: 100,
                          child: Text(
                            'BBAM BBAM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          height: 80,
                          child: emailInput(),
                        ),
                        SizedBox(
                          width: 350,
                          height: 80,
                          child: passwordInput(),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 300,
                              height: 60,
                              child: loginButton(),
                            )),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: 300,
                              height: 60,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Signup()),
                                  );
                                },
                                child: const Text(
                                  '회원가입',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ))
                      ],
                    )))));
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _pwController,
      obscureText: true,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      decoration: const InputDecoration(
          hintText: 'password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          )),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      decoration: const InputDecoration(
          hintText: 'email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          )),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          try {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailController.text, password: _pwController.text)
                .then((_) => {
                      //Navigator.of(context).pushReplacementNamed("/home"),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      )
                    });
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("사용자 정보가 일치하지 않습니다."),
              duration: Duration(seconds: 1),
            ));
            // if (e.code == 'user-not-found') {
            //   debugPrint('No user found for that email.');
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text("이메일 사용자 정보가 존재하지 않습니다."),
            //     duration: Duration(seconds: 1),
            //   ));
            // } else if (e.code == 'wrong-password') {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text("비밀번호가 일치하지 않습니다."),
            //     duration: Duration(seconds: 1),
            //   ));
            //   debugPrint('Wrong password provided for that user.');
            // }
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
      ),
      child: const Text(
        '로그인',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
      ),
    );
  }
}
