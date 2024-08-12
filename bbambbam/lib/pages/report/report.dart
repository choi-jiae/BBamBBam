import 'package:flutter/material.dart';
import 'package:bbambbam/pages/report/report_mockdata.dart';
import 'package:bbambbam/pages/report/report_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbambbam/pages/report/report_total.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bbambbam/pages/report/monthly_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> drivingRecords = [];
  PageController _pageController = PageController();
  int _currentPage = DateTime.now().month - 1;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;

  Future<List<dynamic>>getUserReport() async {

    DocumentSnapshot userReport =
        await FirebaseFirestore.instance.collection('Report').doc(uid).get();

    if (userReport.exists) {
      var data = userReport.data() as Map<String, dynamic>;
      drivingRecords = data['drivingRecords'].reversed.toList();
    }
    
    return drivingRecords;
  }

@override
void initState() {
  super.initState();
  _initializeData();
}

Future<List<dynamic>> _initializeData() async {
  var report = await getUserReport();

  return report;
  
}


  List<dynamic> getFilteredReports(int month) {
    return drivingRecords.where((record) {
      DateTime date = DateTime.parse(record['date']);
      return date.month == month;
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          '나의 운전 리포트',
          style: TextStyle(
              color: Colors.black45, fontSize: 25, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
      child: FutureBuilder(
        future: _initializeData(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('운전 리포트가 없습니다.'));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                MonthlyReport(drivingRecords: snapshot.data),
                TableCalendar(
                  locale: 'ko_KR',
                  focusedDay: DateTime.now(), 
                  firstDay: DateTime.utc(2000, 1, 1), // 첫 운전 시작일
                  lastDay: DateTime.utc(2100, 12, 31), // 마지막 운전 시작일로 수정하면 좋을 듯 근데 느려서 일단..패스
                ),  
                
                ]);
            
          } else {
            return const Center(child: Text('운전 리포트가 없습니다.'));
          }
        },
      ),)
    );
  }
}
