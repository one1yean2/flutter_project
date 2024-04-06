import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeWriter extends StatefulWidget {
  final String actualText;
  final bool typingIndicator;
  final double textSize;
  final Duration duration;
  final Color textColor;
  TypeWriter({
    Key? key,
    required this.actualText,
    this.typingIndicator = false,
    this.textSize = 40,
    this.duration = const Duration(milliseconds: 200),
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  State<TypeWriter> createState() => _TypeWriterState();
}

class _TypeWriterState extends State<TypeWriter> {
  String _actualText = '';
  String _text = '';
  late bool _typingIndicator;
  late int _textLength;
  late int _index;
  late bool _isForward;
  @override
  void initState() {
    super.initState();
    _actualText = widget.actualText;
    _textLength = _actualText.length;
    _typingIndicator = widget.typingIndicator;
    _index = 0;
    _isForward = true;
    Timer.periodic(Duration(milliseconds: widget.duration.inMilliseconds), (timer) {
      if (_isForward) {
        _index++;
        if (_index > _textLength) {
          _index--;
          _isForward = false;
        }
      }

      if (_typingIndicator) {
        setState(() {
          if (_text == _actualText + "_") {
            _text = _actualText;
          } else {
            _text = _actualText.substring(0, _index) + "_";
          }
        });
      } else {
        setState(() {
          _text = _actualText.substring(0, _index);
        });
      }

      if (_index == _textLength && !_typingIndicator) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Text(
          _text,
          style: GoogleFonts.poppins(
            color: widget.textColor,
            fontSize: widget.textSize,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // alignment: Alignment.center,
    );
  }
}
