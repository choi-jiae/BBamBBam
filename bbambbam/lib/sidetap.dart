import 'package:bbambbam/contact.dart';
import 'package:bbambbam/login.dart';
import 'package:bbambbam/mypage.dart';
import 'package:bbambbam/qna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sidetap extends StatefulWidget {
  const Sidetap({super.key});

  @override
  State<Sidetap> createState() => _SidetapState();
}

class _SidetapState extends State<Sidetap> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  getUserInfo() async {
    var result =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
    return result.data();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder(
            future: getUserInfo(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Drawer(
                      child: ListView(children: [
                      UserAccountsDrawerHeader(
                        currentAccountPicture: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/image/pubao.jpg')),
                        // Icon(
                        //   Icons.account_circle,
                        // ),
                        accountName: Padding(
                          padding:
                              const EdgeInsets.only(top: 10), // 계정 이름에 위쪽 패딩 추가
                          child: Text(
                            (snapshot.data as Map)['Name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        accountEmail: Text((snapshot.data as Map)['Email']),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[400],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      MenuBuilder(name: "About", icondata: Icons.info_outline),
                      MenuBuilder(
                          name: "마이페이지",
                          icondata: Icons.person_outline,
                          destination: Mypage()),
                      MenuBuilder(
                          name: "자주 묻는 질문",
                          icondata: Icons.question_answer,
                          destination: QNA()),
                      MenuBuilder(
                          name: "1:1 문의",
                          icondata: Icons.mail_outline,
                          destination: Contact()),
                      MenuBuilder(name: "설정", icondata: Icons.settings),
                      ListTile(
                        leading: Icon(Icons.logout),
                        iconColor: Colors.blue,
                        focusColor: Colors.blue,
                        title: Text("로그아웃"),
                        onTap: () async {
                          await _logout();
                          // 로그아웃 후에 다른 화면으로 이동하거나 로그인 화면으로 돌아가는 로직을 추가할 수 있습니다.
                          // 예를 들어 로그인 화면으로 돌아간다면:
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                      )
                      //알림
                    ]))
                  : Center(child: CircularProgressIndicator());
            }));
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget MenuBuilder(
      {String name = "HOME",
      IconData icondata = Icons.home,
      Widget? destination}) {
    return ListTile(
        leading: Icon(icondata),
        iconColor: Colors.blue,
        focusColor: Colors.blue,
        title: Text(name),
        onTap: () {
          if (destination != null) {
            // Navigator.pushNamed("/")
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => destination));
          }
        },
        trailing: Icon(Icons.navigate_next));
  }
}
