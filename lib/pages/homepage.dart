import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:Flutter_Project/pages/gamepage.dart';

import '../models/quotes.dart';
import '../pages/leaderboard.dart';
import 'package:Flutter_Project/pages/loginpage.dart';
import 'package:Flutter_Project/pages/registerpage.dart';
import 'package:Flutter_Project/widgets/button.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/api_caller.dart';
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
  bool clickChoice = true;
  bool isSelect = true;

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

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 20,
      shadowColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                child: Icon(Icons.person, size: 100),
              ),
            ),
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
    );
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
      drawer: buildDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TypeWriter(actualText: 'Typing Game\n     By One1', typingIndicator: true),
            ).animate().fadeIn(duration: Duration(seconds: 2)),
            SizedBox(height: 40),
            Button(
              actualText: 'MODES',
              onPressed: () {
                setState(() {
                  clickChoice = !clickChoice;
                });
              },
            ).animate(delay: Duration(milliseconds: 500)).fadeIn(duration: Duration(seconds: 1)).slide(duration: Duration(seconds: 1), begin: Offset(0, 5)),
            clickChoice
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
                                width: 240,
                                child: index == 0
                                    ? Button(
                                        actualText: 'Random Quote',
                                        textSize: 15,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => GameScreen(
                                                appBarText: 'Random Quote',
                                                skip: Random().nextInt(1454),
                                                limit: 1,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Button(
                                        actualText: 'Select Quote',
                                        textSize: 15,
                                        onPressed: () {
                                          setState(() {
                                            isSelect = !isSelect;
                                          });
                                        },
                                      )),
                          ).animate(delay: Duration(milliseconds: 500 * index)).fadeIn(duration: Duration(seconds: 1)).slideX(duration: Duration(seconds: 1), begin: 0);
                        },
                        itemCount: 2),
                  ),
            SizedBox(height: 20),
            isSelect
                ? Container()
                : Container(
                    width: 200,
                    child: TextField(
                      autofocus: true,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quote Id (1-1454)',
                      ),
                      onSubmitted: (value) {
                        if (int.parse(value) > 0 && int.parse(value) < 1455) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameScreen(
                                appBarText: 'Selected Quote ID : $value',
                                skip: int.parse(value) - 1,
                                limit: 1,
                              ),
                            ),
                          );
                        } else {
                          //show error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a valid quote id.',
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ).animate(delay: Duration(milliseconds: 200)).fadeIn(duration: Duration(seconds: 1)).slideX(duration: Duration(seconds: 1), begin: 0),
                  ),
            SizedBox(height: 20),
            Button(
              actualText: 'Leaderboard',
              onPressed: () {
                Storage().checkToken().then((value) {
                  if (!value) {
                    showDialog<void>(
                      context: context,
                      builder: (builder) => AlertDialog(
                        title: TypeWriter(
                          actualText: "Login First",
                          textSize: 20,
                          duration: Duration(milliseconds: 1),
                          textColor: Colors.red,
                        ),
                        content: TypeWriter(
                          actualText: "Login first to see leaderboard",
                          duration: Duration(milliseconds: 1),
                          textSize: 15,
                        ),
                        actions: [
                          TextButton(
                            child: TypeWriter(
                              actualText: "OK",
                              duration: Duration(milliseconds: 1),
                              textSize: 15,
                              textColor: Colors.green,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Leaderboard()));
                  }
                });
              },
            ).animate(delay: Duration(seconds: 1)).fadeIn(duration: Duration(seconds: 1)).slide(duration: Duration(seconds: 1), begin: Offset(0, 5)),
          ],
        ),
      ),
    );
  }
}
