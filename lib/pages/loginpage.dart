import 'dart:convert';

import 'package:Flutter_Project/widgets/button.dart';
import 'package:flutter/material.dart';
import '../services/storage.dart';
import '../services/api_caller.dart';
import './homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  bool click = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      checkToken().then((value) {
        if (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Homepage()),
          );
        }
      });
    });
  }

  Future<bool> checkToken() async {
    var token = await Storage().read(Storage.keyToken);
    debugPrint('Token: $token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 40.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
              ),
              Icon(Icons.security, size: 80.0),
              Text('LOGIN', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20.0),
              Container(
                width: 500,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 500,
                child: TextField(
                  // obscureText: true,
                  // obscuringCharacter: '*',
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Button(
                actualText: 'Login',
                onPressed: () async {
                  if (!click) {
                    click = true;
                    print('Username: ${_usernameController.text}');
                    print('Password: ${_passwordController.text}');
                    var caller = ApiCaller();
                    var data = await caller.post(ApiCaller.host, 'login', params: {
                      "username": _usernameController.text,
                      "password": _passwordController.text,
                    });
                    var json = jsonDecode(data);

                    if (json['error'] == 'Username and password are required') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Username and password are required'),
                      ));
                    } else if (json['error'] == "Not Found") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User Not Found'),
                      ));
                    } else {
                      var token = json['token'];
                      var displayName = json['user']['displayName'];

                      var storage = Storage();
                      await storage.write(Storage.keyDisplayName, displayName);
                      await storage.write(Storage.keyToken, token);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Homepage()),
                      );
                    }
                  }
                },
                // child: SizedBox(
                //   width: double.infinity,
                //   child: Text('Login', textAlign: TextAlign.center),
                // ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ));
  }
}
