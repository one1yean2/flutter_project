import 'dart:convert';

import 'package:Flutter_Project/widgets/type_writer.dart';
import 'package:flutter/material.dart';

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
      final data = await ApiCaller().get("http://localhost:3000", "score");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TypeWriter(
          actualText: 'Leaderboard',
          textSize: 25,
        ),
      ),
      body: Column(
        children: [
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _users[index].displayName!,
                        ),
                        subtitle: Text(
                          "Games : " + _users[index].scores!.length.toString(),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
