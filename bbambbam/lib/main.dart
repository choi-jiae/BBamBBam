import 'package:bbambbam/contact.dart';
import 'package:bbambbam/home.dart';
import 'package:bbambbam/landing.dart';
import 'package:bbambbam/login.dart';
import 'package:bbambbam/mypage.dart';
import 'package:bbambbam/qna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

final routes = {
  "/": (context) => const landing(),
  "/login": (context) => const Login(),
  "/home": (context) => const Home(),
  "/my": (context) => const Mypage(),
  "/contact": (context) => const Contact(),
  "/qna": (context) => const QNA(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final shortcuts = Map.of(WidgetsApp.defaultShortcuts);
    shortcuts[LogicalKeySet(LogicalKeyboardKey.space)] = ActivateIntent();

    return MaterialApp(
      shortcuts: kIsWeb ? shortcuts : null,
      //scrollBehavior: MyCustomScrollBehavior(),

      title: 'BBAM BBAM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: routes,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(home: landing());
//   }
// }
