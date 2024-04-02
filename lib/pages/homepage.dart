import 'dart:async';

import 'package:Flutter_Project/helpers/type_writer.dart';
import 'package:Flutter_Project/pages/gamepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String text = 'Start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypeWriter(actualText: 'Typing Game\n     By One1'),
            SizedBox(height: 40),
            Container(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  elevation: 10,
                  shadowColor: Colors.white,
                ),
                onHover: (value) {
                  String startText = 'START';
                  int textLength = startText.length;
                  int index = 0;
                  if (value) {
                    Timer.periodic(Duration(milliseconds: 60), (timer) {
                      if (index < textLength) {
                        index++;
                      } else {
                        timer.cancel();
                      }
                      setState(() {
                        text = startText.substring(0, index);
                      });
                    });
                  }
                },
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuoteScreen(),
                    ),
                  );
                },
                child: Text(
                  text,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
