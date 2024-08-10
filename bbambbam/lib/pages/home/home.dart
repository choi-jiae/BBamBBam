import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bbambbam/pages/driving/driving.dart';
import 'package:bbambbam/pages/report/report.dart';
import 'package:bbambbam/pages/home/sidetap/sidetap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        // leading: const IconButton(
        //     icon: Icon(Icons.menu, color: Colors.white, size: 30),
        //     onPressed: null // hamburger menu 연결하기
        //     ),
        title: const Text(
          'BBAM BBAM',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Sidetap(),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          // Positioned(
          //   top: 340,
          //   left: 65,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const Driving()),
          //       );
          //     },
          //     child: Image.asset(
          //       'assets/images/handle.png',
          //       width: 300,
          //       height: 300,
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment(0, 0.15), // 이 값을 조절하여 위치를 정확히 조정하세요.
            child: GestureDetector(
              onTap: () => _onTapCamera(context),
              child: Image.asset(
                'assets/images/handle.png',
                width: 300,
                height: 300,
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 70.w,
        height: 70.h,
        child:FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Report()),
            );
          },
          child: Icon(
            Icons.article_outlined, 
            color: Colors.black38,
            size: 40,),
          backgroundColor: Colors.white,
      ),)
    );
  }
}

void _onTapCamera(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Driving()),
  );
}

