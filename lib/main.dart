import 'package:flutter/material.dart';
import 'loading_screen.dart'; // Import the SplashScreen widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> globalNavKey = GlobalKey();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavKey,
      home: const LoadingScreen(), // Use the SplashScreen widget as the initial screen
    );
  }
}
