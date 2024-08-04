import 'package:flutter/material.dart';

class ReportTotal extends StatelessWidget {
  final num totalWarningThisWeek;
  final int peakWarningTime;
  const ReportTotal(this.totalWarningThisWeek, this.peakWarningTime, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      height: 150,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
            ),
            ),
            child: Column(
              children: [
                const Text(
                  '지난 일주일간\n 졸음운전 위험 횟수',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalWarningThisWeek',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ],),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
            ),
            ),
            child:Column(
              children: [
                const Text(
                  '졸음 운전을\n가장 많이 하는 시간대',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '$peakWarningTime~${peakWarningTime + 1}시',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),

              ],)
          ),
        ],
      ),
    );
  }
}