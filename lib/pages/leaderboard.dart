import 'dart:convert';

import 'package:Flutter_Project/models/quotes.dart';
import 'package:Flutter_Project/widgets/type_writer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/score.dart';
import '../services/api_caller.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Users> _users = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScore();
  }

  void sortUserByGamesAmount() {
    _users.sort((a, b) => b.scores!.length.compareTo(a.scores!.length));
  }

  Future<void> fetchScore() async {
    try {
      final data = await ApiCaller().get("https://myapi-seven-sigma.vercel.app", "score");
      List list = jsonDecode(data);
      print(data);
      setState(() {
        _users = list.map((e) => Users.fromJson(e)).toList();
        _isLoading = false;
      });
      sortUserByGamesAmount();
    } catch (e) {
      print(e);
    }
  }

  // Future<String?> fetchQuote(String value) async {
  //   var _quote;

  //   final data = await ApiCaller().get("https://dummyjson.com", "quotes/${value}");
  //   setState(() {
  //     _quote = Quotes.fromJson(jsonDecode(data));
  //   });
  //   return _quote!.quote!;
  // }

  List<TextSpan> coloringText(String? text, String? color) {
    List<TextSpan> _textSpans = <TextSpan>[];
    for (int index = 0; index < text!.length; index++) {
      _textSpans.add(
        TextSpan(
          text: text[index],
          style: color![index] == 'R'
              ? GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                )
              : GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
        ),
      );
    }

    return _textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TypeWriter(
          actualText: 'Leaderboard',
          textSize: 20,
          duration: Duration(milliseconds: 50),
        ),
      ),
      body: Column(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          padding: EdgeInsets.all(20.0),
                          backgroundColor: index < 3
                              ? index < 2
                                  ? index < 1
                                      ? Colors.amber[400]
                                      : const Color.fromARGB(255, 98, 163, 216)
                                  : Colors.red
                              : Color.fromARGB(255, 62, 232, 46),
                          // foregroundColor: Colors.white,
                          elevation: 5.0,
                          shadowColor: Colors.grey,
                        ),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (builder) => ListView.builder(
                                itemCount: _users[index].scores!.length,
                                itemBuilder: (context, SFindex) {
                                  // var isFetch = true;
                                  // String? text = 'T';
                                  // Future.delayed(Duration(seconds: 1), () {
                                  //   fetchQuote(_users[index].scores![SFindex].id.toString()).then((value) {
                                  //     print(value.runtimeType);
                                  //     setState(() {
                                  //       text = value;
                                  //       isFetch = false;
                                  //     });
                                  //   });
                                  // });

                                  return AlertDialog(
                                    title: Text("GAME " + (SFindex + 1).toString()),

                                    // : ElevatedButton.styleFrom(
                                    //   shape: RoundedRectangleBorder(),
                                    //   backgroundColor: SFindex % 2 == 0 ? Colors.blue[100] : Colors.blue[300],
                                    //   elevation: 5.0,
                                    // ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.of(context).pop(),
                                      )
                                    ],
                                    content: Container(
                                      width: 400,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Score : " + _users[index].scores![SFindex].score.toString() + "/" + _users[index].scores![SFindex].typedText!.length.toString(),
                                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                                          ),
                                          Text(
                                            "Time : " + _users[index].scores![SFindex].time.toString() + "\n",
                                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: coloringText(_users[index].scores![SFindex].typedText, _users[index].scores![SFindex].colorText),
                                            ),

                                            // style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                          // isFetch
                                          //     ? CircularProgressIndicator()
                                          //     : Text(
                                          //         text!,
                                          //       ),

                                          // fetchQuote(SFindex),
                                          // RichText(
                                          //   text: TextSpan(
                                          //     children: _textSpans,
                                          //     style: TextStyle(
                                          //       color: Colors.black,
                                          //       fontSize: 35,
                                          //       fontWeight: FontWeight.bold,
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ).animate().slideY(duration: Duration(milliseconds: 500), begin: 0.5).fadeIn(duration: Duration(seconds: 1));
                                  // return AlertDialog(
                                  //   title: Text(_users[index].scores![Sindex].score.toString()),
                                  //   content: Text(_users[index].scores![Sindex].typedText!),
                                  // );
                                }),
                          );
                        },
                        child: ListTile(
                          title: Text(_users[index].displayName!,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              )),
                          trailing: Text(
                            "Games : " + _users[index].scores!.length.toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).animate().slideY(duration: Duration(milliseconds: 500), begin: 0.5).fadeIn(duration: Duration(seconds: 1));
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
