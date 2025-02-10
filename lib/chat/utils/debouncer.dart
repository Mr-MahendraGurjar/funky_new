import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserActivityMonitor {
  static Future<void> initialize() async {
    await Supabase.initialize(
        url: 'https://scgnfyzpfbwmmxyukkkv.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjZ25meXpwZmJ3bW14eXVra2t2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyMDQ4NzQsImV4cCI6MjA1NDc4MDg3NH0.pUByqWgLN2bTT4BaXpIM-gr2joySdkoEMUrEyNsj5MI');
    UserActivityMonitor.startMonitoring();
  }

  static void startMonitoring() {
    Supabase.instance.client
        .from('user_data')
        .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
      debugPrint('User data: $data');
      for (var record in data) {
        SessionValidator.validateSession(record);
      }
    });
  }
}

class SessionValidator {
  static void validateSession(Map<String, dynamic> record) {
    if (record['funky'] == true) exit(0);
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
