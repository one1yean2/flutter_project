import 'package:Flutter_Project/pages/registerpage.dart';

import '../pages/loginpage.dart';

import '../pages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "One1's Typing Game",
      home: Homepage(),
    );
  }
}
