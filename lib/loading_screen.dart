import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_store_app/home_screen.dart';
import 'alert.dart';
import 'login_screen.dart';
import 'shared_prefs.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Map<String, dynamic> user = {'uid': '#false#'};

  Future<void> setUserData() async {
    String userRaw = await getLocalData('user') as String;
    if (userRaw != '') {
      setState(() {
        user = json.decode(userRaw);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setUserData();
    Future.delayed(const Duration(seconds: 1), () {
      if(user['uid'] != '#false#') {
        Alerts.showSuccess("You are logged in as: ${user['uid']}");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(user: user,),
          ),
        );
      } else {
        Alerts.showGeneral("Please login or register to continue");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginRegisterPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/app.png',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          // Centered Loading Indicator
          const Center(
            child: CircularProgressIndicator(color:Colors.black),
          ),
        ],
      ),
    );
  }
}
