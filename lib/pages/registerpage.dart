import 'dart:convert';

import 'package:Flutter_Project/pages/loginpage.dart';
import 'package:flutter/material.dart';
import '../services/storage.dart';
import '../services/api_caller.dart';
import './homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _displayNameController = TextEditingController();

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
              Icon(Icons.security, size: 80.0),
              Text('Register', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  print('Username: ${_usernameController.text}');
                  print('Password: ${_passwordController.text}');
                  var caller = ApiCaller();
                  var data = await caller.post("http://localhost:3000", 'register', params: {
                    "username": _usernameController.text,
                    "password": _passwordController.text,
                    "displayName": _displayNameController.text,
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text('Register', textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ));
  }
}
