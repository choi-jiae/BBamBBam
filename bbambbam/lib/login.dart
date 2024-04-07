import 'package:bbambbam/signup.dart';
import 'package:flutter/material.dart';
import 'package:bbambbam/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color.fromARGB(255, 248, 249, 250),
            child: Center(
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
                  child: TextFormField(
                    controller: idController,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                        hintText: '아이디',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        )),
                  ),
                ),
                SizedBox(
                  width: 350,
                  height: 80,
                  child: TextFormField(
                    controller: pwController,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                        hintText: '비밀번호',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        )),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
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
            ))));
  }
}
