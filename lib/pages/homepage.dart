import 'dart:async';
import 'package:Flutter_Project/pages/leaderboard.dart';
import 'package:Flutter_Project/pages/registerpage.dart';
import 'package:Flutter_Project/widgets/button.dart';

import '../services/storage.dart';
import '../widgets/type_writer.dart';
import '../pages/gamepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loginpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String text = 'Start';
  String dropdownvalue = 'Register';
  String username = 'Guest';
  var items = ['Register', 'Login'];
  bool name = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      getName().then((value) {
        setState(() {
          username = value;
          name = false;
        });
      });
    });
  }

  Future<String> getName() async {
    var displayName = await Storage().read(Storage.keyDisplayName);
    debugPrint('displayName: $displayName');
    return displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: name
          ? AppBar()
          : AppBar(
              title: TypeWriter(
                actualText: 'Welcome ${username} !',
              ),
              backgroundColor: Colors.white,
              // foregroundColor: Colors.white,
              elevation: 20,
              shadowColor: Colors.white,
            ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 20,
        shadowColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // TODO: add navgiation to register and login
            DrawerHeader(
              child: Center(child: Container(height: 100, width: 100, child: Icon(Icons.person, size: 100))),
            ),
            ListTile(
                title: Text('Register'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                }),
            ListTile(
                title: Text('Login'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                })
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: TypeWriter(actualText: 'Typing Game\n     By One1', typingIndicator: true)),
            SizedBox(height: 40),
            Button(
              actualText: 'START',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen()));
              },
            ),
            SizedBox(height: 40),
            Button(
              actualText: 'Leaderboard',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Leaderboard()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
