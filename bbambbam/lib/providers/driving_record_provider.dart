import 'package:flutter/foundation.dart';

class DrivingRecord with ChangeNotifier {
  Map<String, dynamic> _drivingRecord = {
    'date': '2023-10-12',
    'count': 0,
    'timestamp': [],
    'total': '00:00:00',
    'warning': false,
  };

  Map<String, dynamic> get drivingRecord => _drivingRecord;

  void updateDrivingRecord(Map<String, dynamic> newRecord) {
    _drivingRecord = newRecord;
    notifyListeners(); // 상태 변경 알림
  }

  void updateField(String key, dynamic value) {
    _drivingRecord[key] = value;
    notifyListeners(); // 상태 변경 알림
  }
}
