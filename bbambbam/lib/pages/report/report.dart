import 'package:flutter/material.dart';
import 'package:bbambbam/pages/report/report_mockdata.dart';
import 'package:bbambbam/pages/report/report_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  getUserReport() async {
    var reports =
        await FirebaseFirestore.instance.collection('User').doc(uid).collection('Reports').get();
    List<Map<String, dynamic>> reportList = [];
    for (var report in reports.docs) {
      reportList.add(report.data());
    }
    print(reportList);
    return reportList;
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
            builder: (context, AsyncSnapshot<dynamic> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('운전 리포트가 없습니다.'));
              }else if (snapshot.hasData) {
                var reports = snapshot.data as List;
              return SingleChildScrollView(
                child:  Column(
                children: <Widget>[
                  Container(
                    height: 5,
                    width: 50,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('📑 운전 리포트', style: TextStyle(color:Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),),
                        ...reports.map((report) => ReportItem(report)), // mockData의 각 항목을 ReportItem으로 변환
                      ],
                    ),),
                  )
                ],
              ),
              );
            } else{
              return const Center(child: Text('운전 리포트가 없습니다.'));
            }
            },
          ),
        );
  }
}