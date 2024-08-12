import 'package:flutter/material.dart';
import 'package:bbambbam/pages/report/report_item.dart';
import 'package:bbambbam/pages/report/report_total.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyReport extends StatefulWidget {
  final List<dynamic> drivingRecords;
  const MonthlyReport({super.key, required this.drivingRecords});

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {

    num getTotalWarningThisWeek(List<dynamic> drivingRecords) {
    num totalWarningThisWeek = 0;

    for (var record in drivingRecords) {
      if (record['warning']) {
        totalWarningThisWeek += record['count'];
      }
    }
    return totalWarningThisWeek;
  }

  int getPeakWarningTime(List<dynamic> drivingRecords) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: ReportTotal(
            getTotalWarningThisWeek(widget.drivingRecords), 
            getPeakWarningTime(widget.drivingRecords)),
          ),

      ],
    );
  }
}