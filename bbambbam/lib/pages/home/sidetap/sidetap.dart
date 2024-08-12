import 'package:bbambbam/pages/auth/login.dart';
import 'package:bbambbam/pages/home/sidetap/about.dart';
import 'package:bbambbam/pages/home/sidetap/contact.dart';
import 'package:bbambbam/pages/home/sidetap/mypage.dart';
import 'package:bbambbam/pages/home/sidetap/qna.dart';
import 'package:bbambbam/providers/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidetap extends StatelessWidget {
  const Sidetap({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: true);

    return Drawer(
      backgroundColor: Colors.white,
      child: userInfoProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator()) // 정보가 준비되지 않았다면 인디케이터 표시
          : ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: Image.network(
                            userInfoProvider.userInfo?['UserImage'] ?? '')
                        .image,
                  ),
                  accountName: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      userInfoProvider.userInfo?['Name'] ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  accountEmail: Text(userInfoProvider.userInfo?['Email'] ?? ''),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                MenuBuilder(
                  context,
                  name: "About",
                  path: "/about",
                  icondata: Icons.info_outline,
                  destination: const About(),
                ),
                MenuBuilder(
                  context,
                  name: "마이페이지",
                  path: "/my",
                  icondata: Icons.person_outline,
                  destination: const Mypage(),
                ),
                MenuBuilder(
                  context,
                  name: "자주 묻는 질문",
                  path: "/qna",
                  icondata: Icons.question_answer,
                  destination: const QNA(),
                ),
                MenuBuilder(
                  context,
                  name: "1:1 문의",
                  path: "/contact",
                  icondata: Icons.mail_outline,
                  destination: const Contact(),
                ),
                MenuBuilder(
                  context,
                  name: "설정",
                  icondata: Icons.settings,
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  iconColor: Colors.blueAccent,
                  focusColor: Colors.blueAccent,
                  title: const Text("로그아웃"),
                  onTap: () async {
                    await _logout(context);
                  },
                ),
              ],
            ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  Widget MenuBuilder(
    BuildContext context, {
    String name = "HOME",
    String path = "/home",
    IconData icondata = Icons.home,
    Widget? destination,
  }) {
    return ListTile(
      leading: Icon(icondata),
      iconColor: Colors.blueAccent,
      focusColor: Colors.blueAccent,
      title: Text(name),
      onTap: () {
        if (destination != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
