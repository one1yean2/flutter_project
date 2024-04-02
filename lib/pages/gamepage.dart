import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/api_caller.dart';
import '../models/quotes.dart';

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  QuotesList _quotes = QuotesList();
  bool _isLoading = true;
  int currentIndex = 0;
  int _currentIndex = 0;
  Color textColor = Colors.black;
  TextEditingController textEditingController = TextEditingController();
  List<TextSpan> _textSpans = [];
  List<TextSpan> _buildTextSpans(String text, String value) {
    final textSpans = <TextSpan>[];
    for (int i = 0; i < text.length; i++) {
      textSpans.add(
        TextSpan(
          text: i != value.length
              ? i < value.length
                  ? text[i] == ' '
                      ? value[i]
                      : text[i]
                  : text[i]
              : "|" + text[i],
          style: i < value.length
              ? text[i] == value[i]
                  ? GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    )
                  : GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )
              : null,
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
      final data = await ApiCaller().get("quotes");
      setState(() {
        _quotes = QuotesList.fromJson(jsonDecode(data));
        _isLoading = false;
        _textSpans = _buildTextSpans(_quotes.quotes![currentIndex].quote!, '');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   alignment: Alignment.topCenter,
            //   width: double.maxFinite,
            //   color: Colors.black,
            //   height: 60,
            //   child: Row(
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(50),
            //           color: Colors.lightGreenAccent[400],
            //         ),
            //         margin: EdgeInsets.all(4),
            //         child: Center(
            //             child: Text(
            //           '1',
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         )),
            //         width: 50,
            //       ),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: SizedBox(),
            // ),
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
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: TextField(
                                controller: textEditingController,
                                onChanged: (value) {
                                  final newIndex = min(_currentIndex + 1, _quotes.quotes![currentIndex].quote!.length - 1);
                                  setState(() {
                                    _currentIndex = newIndex;
                                    _textSpans = _buildTextSpans(_quotes.quotes![currentIndex].quote!, value);
                                  });
                                  if (value.length == _quotes.quotes![currentIndex].quote!.length) {
                                    setState(() {
                                      currentIndex = currentIndex + 1;
                                      _currentIndex = 0;
                                      _textSpans = _buildTextSpans(_quotes.quotes![currentIndex].quote!, '');
                                      textEditingController.clear();
                                    });
                                  }
                                  // }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Type Here',
                                  border: OutlineInputBorder(),
                                ),
                              )

                              // child: TextField(
                              //   maxLines: null,
                              //   minLines: 1,
                              //   controller: textEditingController,
                              //   decoration: InputDecoration(),
                              //   onChanged: (value) {
                              //     int inputLength = value.length;

                              //     if (_quotes.quotes![currentIndex].quote!.substring(0, inputLength) == value) {
                              //       setState(() {
                              //         //change color of text
                              //         textColor = Colors.green;
                              //       });
                              //     } else {
                              //       setState(() {
                              //         textColor = Colors.red;
                              //       });
                              //     }
                              //     if (value == _quotes.quotes![currentIndex].quote!) {
                              //       setState(() {
                              //         currentIndex = currentIndex + 1;
                              //         textEditingController.clear();
                              //       });
                              //     }
                              //   },
                              //   autofocus: true,
                              //   style: TextStyle(
                              //     color: textColor,
                              //     fontSize: 30,
                              //     fontWeight: FontWeight.normal,
                              //   ),
                              // ),
                              ),
                        ],
                      ),
                    ),
                  ),
            // Expanded(
            //   child: SizedBox(),
            // ),
          ],
        ),
      ),

      // _isLoading
      //     ? Container(
      //         color: Colors.black,
      //         child: Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       )
      //     : ListView.builder(
      //         itemCount: _quotes.quotes!.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Column(
      //             children: [
      //               Text(
      //                 _quotes.quotes![index].quote!,
      //                 style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      //               ),
      //               Container(
      //                 width: 200,
      //                 margin: EdgeInsets.only(top: 20),
      //                 child: TextField(
      //                   autofocus: true,
      //                   // decoration: InputDecoration(
      //                   //   hintText: 'Enter your name',
      //                   //   border: OutlineInputBorder(),
      //                   // ),
      //                   onSubmitted: (value) {
      //                     // Navigator.push(
      //                     // context,
      //                     // MaterialPageRoute(
      //                     // builder: (context) => GamePage(name: value),
      //                     // ),
      //                     // );
      //                   },
      //                 ),
      //               ),
      //             ],
      //           );
      //         },
      //       ),
    );
  }
}
