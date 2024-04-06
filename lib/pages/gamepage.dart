import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:Flutter_Project/pages/homepage.dart';
import 'package:Flutter_Project/widgets/type_writer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_caller.dart';
import '../models/quotes.dart';
import '../services/storage.dart';
import 'leaderboard.dart';

class GameScreen extends StatefulWidget {
  final int skip;
  final int limit;
  final String appBarText;

  GameScreen({
    Key? key,
    required this.appBarText,
    required this.skip,
    required this.limit,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  QuotesList _quotes = QuotesList();
  bool _isLoading = true;
  int currentIndex = 0;
  int _score = 0;
  TextEditingController textEditingController = TextEditingController();
  List<TextSpan> _textSpans = [];
  String colorText = '';
  bool start = false;
  int _time = 0;
  late Timer _timer;

  String? checkText(String text, String value, int index) {
    if (index != value.length) {
      if (index < value.length) {
        if (text[index] == ' ') {
          return value[index];
        } else {
          return text[index];
        }
      } else {
        return text[index];
      }
    } else {
      return text[index];
    }
  }

  TextStyle? checkTextStyle(String text, String value, int index) {
    if (index < value.length) {
      if (text[index] == value[index]) {
        setState(() {
          _score++;
          colorText += 'G';
        });
        return GoogleFonts.poppins(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        );
      } else {
        setState(() {
          colorText += 'R';
        });
        return GoogleFonts.poppins(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );
      }
    } else {
      return null;
    }
  }

  List<TextSpan> _buildTextSpans(String text, String value) {
    final textSpans = <TextSpan>[];
    for (int i = 0; i < text.length; i++) {
      if (i == value.length) {
        textSpans.add(
          TextSpan(
            text: "|",
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
      textSpans.add(
        TextSpan(
          text: checkText(text, value, i),
          style: checkTextStyle(text, value, i),
        ),
      );
    }
    return textSpans;
  }

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    try {
      final data = await ApiCaller().get("https://dummyjson.com", "quotes?skip=${widget.skip}&limit=${widget.limit}");
      setState(() {
        _quotes = QuotesList.fromJson(jsonDecode(data));
        _isLoading = false;
        _textSpans = _buildTextSpans(_quotes.quotes![currentIndex].quote!, '');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> postScore(int id, int score, int time, String typedText, String colorText) async {
    try {
      var data = await ApiCaller().post(ApiCaller.host, 'score', params: {
        "id": id,
        "score": score,
        "time": time,
        "typedText": typedText,
        "colorText": colorText,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TypeWriter(
          actualText: widget.appBarText,
          duration: Duration(milliseconds: 50),
          textSize: 20,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Text(
                      "SCORE : " + _score.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ).animate().slide(duration: Duration(seconds: 1)).fadeIn(duration: Duration(seconds: 1)),
                SizedBox(
                  width: 50,
                ),
                Center(
                  child: Container(
                    child: Text(
                      "TIMER : " + _time.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ).animate().slide(duration: Duration(seconds: 1)).fadeIn(duration: Duration(seconds: 1)),
              ],
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 750,
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: _textSpans,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ).animate().fadeIn(duration: Duration(seconds: 1)).slideY(duration: Duration(milliseconds: 500), begin: 0.5),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: TextField(
                              controller: textEditingController,
                              autofocus: true,
                              maxLength: _quotes.quotes![currentIndex].quote!.length,
                              onChanged: (value) async {
                                //start Timer
                                if (!start) {
                                  start = true;
                                  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                                    setState(() {
                                      _time = _time + 1;
                                    });
                                  });
                                }

                                setState(
                                  () {
                                    _score = 0;
                                    colorText = '';
                                    _textSpans = _buildTextSpans(_quotes.quotes![currentIndex].quote!, value);
                                  },
                                );
                                if (value.length == _quotes.quotes![currentIndex].quote!.length) {
                                  _timer.cancel();
                                  await postScore(_quotes.quotes![currentIndex].id!, _score, _time, value, colorText);

                                  if (currentIndex == _quotes.quotes!.length - 1) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                                title: TypeWriter(actualText: "Complete !", duration: Duration(milliseconds: 50), textSize: 20),
                                                content: TypeWriter(
                                                  actualText: "Your score is " + _score.toString() + " out of " + _quotes.quotes![currentIndex].quote!.length.toString() + " characters",
                                                  duration: Duration(milliseconds: 50),
                                                  textSize: 15,
                                                ),
                                                actions: [
                                                  TextButton(
                                                      child: TypeWriter(
                                                        actualText: "Continue",
                                                        duration: Duration(milliseconds: 50),
                                                        textSize: 20,
                                                        textColor: Colors.green,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: (context) => Homepage(),
                                                          ),
                                                        );
                                                      })
                                                ]));
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    //   builder: (context) => Homepage(),
                                    // ));
                                  } else {
                                    setState(
                                      () {
                                        currentIndex = currentIndex + 1;
                                        start = false;
                                        _time = 0;
                                        _textSpans = _buildTextSpans(_quotes.quotes![currentIndex].quote!, '');
                                        textEditingController.clear();
                                      },
                                    );
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Type Here',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ).animate().fadeIn().slideY(duration: Duration(milliseconds: 700), begin: 1),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
