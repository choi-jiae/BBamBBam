import 'package:flutter/material.dart';

class Sidetap extends StatefulWidget {
  const Sidetap({super.key});

  @override
  State<Sidetap> createState() => _SidetapState();
}

class _SidetapState extends State<Sidetap> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
        currentAccountPicture:
            CircleAvatar(backgroundImage: AssetImage('assets/image/pubao.jpg')),
        // Icon(
        //   Icons.account_circle,
        // ),
        accountName: Padding(
          padding: const EdgeInsets.only(top: 10), // 계정 이름에 위쪽 패딩 추가
          child: Text(
            "푸바오",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        accountEmail: Text('limgm123@naver.com'),
        decoration: BoxDecoration(
          color: Colors.lightBlue[400],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
      ),
      MenuBuilder(name: "About", icondata: Icons.info_outline),
      MenuBuilder(name: "마이페이지", icondata: Icons.person_outline),
      MenuBuilder(name: "자주 묻는 질문", icondata: Icons.question_answer),
      MenuBuilder(name: "1:1 문의", icondata: Icons.mail_outline),
      MenuBuilder(name: "설정", icondata: Icons.settings),
      ListTile(
        leading: Icon(Icons.logout),
        iconColor: Colors.blue,
        focusColor: Colors.blue,
        title: Text("로그아웃"),
        onTap: () {},
      )
      //알림
    ]));
  }

  Widget MenuBuilder({String name = "HOME", IconData icondata = Icons.home}) {
    return ListTile(
        leading: Icon(icondata),
        iconColor: Colors.blue,
        focusColor: Colors.blue,
        title: Text(name),
        onTap: () {},
        trailing: Icon(Icons.navigate_next));
  }
}
