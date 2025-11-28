// lib/main.dart
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'features/home/home_page.dart';
=======
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
>>>>>>> origin/master

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://apcthhdmbegbkgtallpm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFwY3RoaGRtYmVnYmtndGFsbHBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMjU5NzksImV4cCI6MjA3OTkwMTk3OX0.wqDQD8oaYN4dtRzSuKNRgXYUd-2QnQclsVoaJhd7I9w',
  );

  runApp(const RestokInApp());
}

<<<<<<< HEAD
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
=======
final supabase = Supabase.instance.client;
>>>>>>> origin/master
