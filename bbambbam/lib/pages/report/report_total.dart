import 'package:flutter/material.dart';

class ReportTotal extends StatelessWidget {
  final num totalWarningThisWeek;
  final int peakWarningTime;
  const ReportTotal(this.totalWarningThisWeek, this.peakWarningTime, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow:
                  [BoxShadow(color: Color.fromARGB(255, 210, 210, 210), blurRadius: 5, spreadRadius: 1)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '졸음운전 위험 횟수',
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
            height: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
            ),
              boxShadow:
                  [BoxShadow(color: Color.fromARGB(255, 210, 210, 210), blurRadius: 5, spreadRadius: 1)],
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
      );
  }
}