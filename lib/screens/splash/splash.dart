import 'dart:async';

import 'package:exam_app/screens/home/HomePage/HomePage.dart';
import 'package:exam_app/screens/home/home.dart';
import 'package:exam_app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:exam_app/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exam_app/call_api/models/user.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    if (isLogin) {
      String username = prefs.getString('username') ?? "";
      String password = prefs.getString('password') ?? "";
      print(username);
      print(password);
      if (username.isEmpty || password.isEmpty) {
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      } else {
        Map<String, String> params = {};
        params['username'] = username;
        params['password'] = password;
        print('Loginggggg 1');
        String check = await login(http.Client(), params);
        print('Loginggggg 2');
        if (check.isNotEmpty) {
          if (context.mounted) {
            print('Login failed');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          }
        } else {
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          }
        }
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            background,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(image: AssetImage(logo))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
