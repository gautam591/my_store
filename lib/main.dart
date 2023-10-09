import 'package:flutter/material.dart';
import 'loading_screen.dart'; // Import the SplashScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loadingScreen(), // Use the SplashScreen widget as the initial screen
    );
  }
}
