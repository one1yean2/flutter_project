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

  Future<void> fetchScore() async {
    try {
      final data = await ApiCaller().get("http://localhost:3000", "score");
      List list = jsonDecode(data);
      print(data);
      setState(() {
        _users = list.map((e) => Users.fromJson(e)).toList();
        _isLoading = false;
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
          actualText: 'Leaderboard',
          textSize: 25,
        ),
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                Text(_users[0].displayName!),
                Text(_users[1].displayName!),
              ],
            ),
    );
  }
}
