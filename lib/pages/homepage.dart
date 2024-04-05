import 'dart:async';
import 'dart:math';
import 'package:Flutter_Project/pages/gamepage.dart';

import '../pages/leaderboard.dart';
import 'package:Flutter_Project/pages/loginpage.dart';
import 'package:Flutter_Project/pages/registerpage.dart';
import 'package:Flutter_Project/widgets/button.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/storage.dart';
import '../widgets/type_writer.dart';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String username = '';
  var items = ['Register', 'Login'];
  bool hasLoggedIn = false;
  bool test = true;
  @override
  void initState() {
    super.initState();

    Storage().getName().then((value) {
      setState(() {
        username = value;
        hasLoggedIn = true;
      });
    });
  }

  Future<void> deleteStorage() async {
    await Storage().deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasLoggedIn
          ? AppBar(
              title: TypeWriter(
                actualText: 'Welcome ${username} !',
                textSize: 25,
                duration: Duration(milliseconds: 100),
              ),
            )
          : AppBar(),
      drawer: Drawer(
        backgroundColor: Colors.white,
        elevation: 20,
        shadowColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(child: Container(height: 100, width: 100, child: Icon(Icons.person, size: 100))),
            ),
            hasLoggedIn && username != ''
                ? Container()
                : ListTile(
                    title: TypeWriter(
                      actualText: 'REGISTER',
                      textSize: 25,
                      duration: Duration(milliseconds: 60),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                    }),
            hasLoggedIn && username != ''
                ? Container()
                : ListTile(
                    title: TypeWriter(
                      actualText: 'LOGIN',
                      textSize: 25,
                      duration: Duration(milliseconds: 50),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                    }),
            hasLoggedIn && username != ''
                ? ListTile(
                    title: TypeWriter(
                      actualText: 'LOGOUT',
                      textSize: 25,
                      duration: Duration(milliseconds: 40),
                      textColor: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        deleteStorage();
                        hasLoggedIn = false;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage()));
                    })
                : Container(),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TypeWriter(actualText: 'Typing Game\n     By One1', typingIndicator: true),
            ).animate().fadeIn(duration: Duration(seconds: 2)),
            SizedBox(height: 40),
            Button(
              actualText: 'GAMES',
              onPressed: () {
                setState(() {
                  test = !test;
                });
              },
            ).animate(delay: Duration(milliseconds: 500)).fadeIn(duration: Duration(seconds: 1)).slide(duration: Duration(seconds: 1), begin: Offset(0, 5)),
            test
                ? Container()
                : Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                0,
                                10,
                                0,
                                0,
                              ),
                              width: 200,
                              child: Button(
                                actualText: 'Quote $index',
                                textSize: 17,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GameScreen(
                                        skip: Random().nextInt(1047),
                                        limit: 1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ).animate(delay: Duration(milliseconds: 500 * index)).fadeIn(duration: Duration(seconds: 1)).slideX(duration: Duration(seconds: 1), begin: 0);
                        },
                        itemCount: 2),
                  ),
            SizedBox(height: 40),
            Button(
              actualText: 'Leaderboard',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Leaderboard()));
              },
            ).animate(delay: Duration(seconds: 1)).fadeIn(duration: Duration(seconds: 1)).slide(duration: Duration(seconds: 1), begin: Offset(0, 5)),
          ],
        ),
      ),
    );
  }
}
