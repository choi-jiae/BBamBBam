import 'package:flutter/material.dart';
import 'package:bbambbam/pages/report/report_mockdata.dart';
import 'package:bbambbam/pages/report/report_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbambbam/pages/report/report_total.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> drivingRecords = [];

  getUserReport() async {

    DocumentSnapshot userReport =
        await FirebaseFirestore.instance.collection('Report').doc(uid).get();

    if (userReport.exists) {
      var data = userReport.data() as Map<String, dynamic>;
      drivingRecords = data['drivingRecords'].reversed.toList();
    }
    
    return drivingRecords;
  }

  num getTotalWarningThisWeek() {
    num totalWarningThisWeek = 0;
    DateTime oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    for (var record in drivingRecords) {
      if (DateTime.parse(record['date']).isAfter(oneWeekAgo) && record['warning']) {
        totalWarningThisWeek += record['count'];
      }
    }
    return totalWarningThisWeek;
  }

  int getPeakWarningTime() {
    List<num> warningCounts = List.filled(24, 0);
    for (var record in drivingRecords){
      if (record['warning']){
        for (var timestamp in record['timestamp']){
          warningCounts[int.parse(timestamp.split(':')[0])] += 1;
        }
      }
    }
    
    int peakWarningTime = 0;
    for (var i = 0; i < warningCounts.length; i++){
      if (warningCounts[i] > warningCounts[peakWarningTime]){
        peakWarningTime = i;
      }
    }
    return peakWarningTime;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // 화면 높이만큼 설정
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
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
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 5,
                    width: 50,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            '📑 운전 리포트',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ReportTotal(getTotalWarningThisWeek(), getPeakWarningTime()),
                            ),

                          ...reports.map((report) => ReportItem(
                              report)), // mockData의 각 항목을 ReportItem으로 변환
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text('운전 리포트가 없습니다.'));
          }
        },
      ),
    );
  }
}
