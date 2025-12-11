// lib/main.dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://apcthhdmbegbkgtallpm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwY3RoaGRtYmVnYmtndGFsbHBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMjU5NzksImV4cCI6MjA3OTkwMTk3OX0.wqDQD8oaYN4dtRzSuKNRgXYUd-2QnQclsVoaJhd7I9w',
  );

  runApp(const RestokInApp());
}

final supabase = Supabase.instance.client;
