import "dart:async";
import "package:Flutter_Project/pages/homepage.dart";
import "package:Flutter_Project/pages/leaderboard.dart";

import "../pages/gamepage.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class Button extends StatefulWidget {
  final String actualText;
  final VoidCallback? onPressed;
  final double textSize;
  Button({
    Key? key,
    required this.actualText,
    required this.onPressed,
    this.textSize = 20,
  }) : super(key: key);
  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.actualText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
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
          String _startText = widget.actualText;
          int _textLength = _startText.length;
          int _index = 0;

          if (value) {
            Timer.periodic(Duration(milliseconds: 60), (timer) {
              if (_index < _textLength) {
                _index++;
              } else {
                timer.cancel();
              }
              setState(() {
                _text = _startText.substring(0, _index);
              });
            });
          }
        },
        onPressed: widget.onPressed,
        child: Text(
          _text,
          style: GoogleFonts.poppins(fontSize: widget.textSize, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
