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
  DateTime _focusedDay = DateTime.now();
  DateTime _firstDay = DateTime.utc(2024, 1, 1);
  DateTime _lastDay = DateTime.utc(2100, 12, 31);
  DateTime? _selectedDay;
  Map<DateTime, int> _warningCount = {};
  List<dynamic> _monthlyRecords = [];
  List<dynamic> _dailyRecords = [];
  

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

Future<void> _initializeData() async {
  await getUserReport();
  _monthlyRecords = _getMonthlyRecords(_focusedDay);
  _dailyRecords = _getDailyRecords(_focusedDay);
  _calculateWarningCounts(_monthlyRecords);
}

  List<dynamic> _getMonthlyRecords(DateTime month) {
    return drivingRecords.where((record) {
      DateTime recordDate = DateTime.parse(record['date']);
      return recordDate.year == month.year && recordDate.month == month.month;
    }).toList();
  }

  List<dynamic> _getDailyRecords(DateTime day) {
    return drivingRecords.where((record) {
      DateTime recordDate = DateTime.parse(record['date']);
      return recordDate.year == day.year && recordDate.month == day.month && recordDate.day == day.day;
    }).toList();
  }

    void _calculateWarningCounts(List<dynamic> drivingRecords) {
      setState(() {
        _warningCount.clear(); // 기존 경고 카운트를 초기화
        for (var record in drivingRecords) {
          DateTime date = DateTime.parse(record['date']);
          DateTime dateOnly = DateTime(date.year, date.month, date.day); // 날짜 부분만 추출
          _warningCount[dateOnly] = 0;
          if (record['warning'] == true) {
            _warningCount[dateOnly] = _warningCount[dateOnly]! + 1;
    
          }

        }
        print(_warningCount);
      });
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
            return Column(
              children: [
                MonthlyReport(drivingRecords: _monthlyRecords),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                      TableCalendar(
                        locale: 'ko_KR',
                        focusedDay: _focusedDay, 
                        firstDay: _firstDay, // 첫 운전 시작일
                        lastDay: _lastDay, // 마지막 운전 시작일로 수정하면 좋을 듯 근데 느려서 일단..패스
                        calendarFormat : CalendarFormat.month,
                        availableCalendarFormats: const {
                          CalendarFormat.month: '월',
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                            _selectedDay = selectedDay;
                            _dailyRecords = _getDailyRecords(selectedDay);
                          });
                        },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                            _monthlyRecords = _getMonthlyRecords(focusedDay);
                            _dailyRecords = _getDailyRecords(focusedDay);
                            _calculateWarningCounts(_monthlyRecords);
                          }
                          );
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            DateTime dateOnly = DateTime(date.year, date.month, date.day);
                            if (_warningCount.containsKey(dateOnly)) {
                              if (_warningCount[dateOnly]! > 0) {
                                return const Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.redAccent,
                                    size: 16.0,
                                  ),
                                );
                              } else if (_warningCount[dateOnly]! == 0) {
                                return const Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16.0,
                                  ),
                                );
                              }
                            }
                            return Container();
                          },
                        ),
                      ), 
                      Column(
                        children: _dailyRecords.map((record) => ReportItem(record)).toList(),
                      ),
                      ],),),)
 
                
                ]);
            
          } else {
            return const Center(child: Text('운전 리포트가 없습니다.'));
          }
        },
      ),)
    );
  }
}
