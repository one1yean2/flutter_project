import 'dart:math';

import 'package:flutter/material.dart';

final wordsList = [
  'apple',
  'banana',
  'cherry',
  'date',
  'fig',
  'grape',
  'kiwi',
  'lemon',
  'mango',
  'orange',
];

class TypingGame extends StatefulWidget {
  @override
  _TypingGameState createState() => _TypingGameState();
}

class _TypingGameState extends State<TypingGame> {
  TextEditingController _textController = TextEditingController();
  String _currentWord = '';
  int _score = 0;
  int _timeLeft = 60;
  int _currentIndex = 0;
  List<TextSpan> _textSpans = [];

  @override
  void initState() {
    super.initState();
    _startNewWord();
  }

  void _startNewWord() {
    setState(() {
      _currentWord = wordsList.removeAt(Random().nextInt(wordsList.length));
      _currentIndex = 0;
      _textSpans = _buildTextSpans(_currentWord);
      _textController.clear();
    });
  }

  void _checkInput() {
    if (_textController.text.toLowerCase().trim() == _currentWord) {
      setState(() {
        _score++;
        _startNewWord();
      });
    }
  }

  List<TextSpan> _buildTextSpans(String text) {
    final textSpans = <TextSpan>[];
    for (int i = 0; i < text.length; i++) {
      textSpans.add(TextSpan(
        text: text[i],
        // style: i == _currentIndex
        // ?
        style: i < _currentIndex
            ? TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              )
            : null,
      ));
    }
    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Time Left: $_timeLeft',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: _textSpans,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _textController,
              onChanged: (value) {
                if (value.toLowerCase().trim() == _currentWord) {
                  _checkInput();
                } else {
                  final newIndex = min(_currentIndex + 1, _currentWord.length - 1);
                  setState(() {
                    _currentIndex = newIndex;
                    _textSpans = _buildTextSpans(_currentWord);
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Type Here',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
