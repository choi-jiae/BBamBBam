import 'dart:async';

import 'package:bbambbam/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class landing extends StatefulWidget {
  const landing({super.key});

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.to(Login());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.blue, child: const Center(child: Text("BBam BBam"))));
  }
}
