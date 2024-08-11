import 'package:flutter/material.dart';
import 'package:bbambbam/pages/report/report_mockdata.dart';
import 'package:bbambbam/pages/report/report_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbambbam/pages/report/report_total.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbambbam/pages/report/monthly_report.dart';


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

  getUserReport() async {

    DocumentSnapshot userReport =
        await FirebaseFirestore.instance.collection('Report').doc(uid).get();

    if (userReport.exists) {
      var data = userReport.data() as Map<String, dynamic>;
      drivingRecords = data['drivingRecords'].reversed.toList();
    }
    
    return drivingRecords;
  }

  List<dynamic> getFilteredReports(int month) {
    return drivingRecords.where((record) {
      DateTime date = DateTime.parse(record['date']);
      return date.month == month;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getUserReport();
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
        future: getUserReport(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('운전 리포트가 없습니다.'));
          } else if (snapshot.hasData) {
            var reports = snapshot.data as List;
            return Column(
              children: [
                MonthlyReport(drivingRecords: reports)
                
                ]);
            
          } else {
            return const Center(child: Text('운전 리포트가 없습니다.'));
          }
        },
      ),)
    );
  }
}
