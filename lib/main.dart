import 'package:Flutter_Project/pages/gamepage.dart';
import 'package:Flutter_Project/pages/homepage.dart';
import 'package:Flutter_Project/pages/test.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}
