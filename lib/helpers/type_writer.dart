import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeWriter extends StatefulWidget {
  final String actualText;

  TypeWriter({
    Key? key,
    required this.actualText,
  }) : super(key: key);

  @override
  State<TypeWriter> createState() => _TypeWriterState();
}

class _TypeWriterState extends State<TypeWriter> {
  String actualText = '';
  String text = '';
  late int _textLength;
  late int _index;
  late bool _isForward;
  @override
  void initState() {
    super.initState();
    actualText = widget.actualText;
    _textLength = actualText.length;
    _index = 0;
    _isForward = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_isForward) {
        _index++;
        if (_index > _textLength) {
          _index--;
          _isForward = false;
        }
      }
      // if (!_isForward) {
      //   _index--;
      //   // if (_index < Random().nextInt(_textLength)) {
      //   if (_index < 0) {
      //     _index++;
      //     _isForward = true;
      //   }
      // }
      setState(() {
        if (text == actualText + "_") {
          text = actualText;
        } else {
          text = actualText.substring(0, _index) + "_";
        }
        // text = actualText.substring(0, _index) + "_" + actualText.substring(_index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 40.0,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      alignment: Alignment.center,
    );
  }
}
