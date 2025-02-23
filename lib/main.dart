import 'package:flutter/material.dart';
import 'home.dart'; // Home 화면 import
import 'SplashScreen.dart'; // SplashScreen (스플래시 화면) import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUMOS App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(), // 스플래시 화면을 먼저 실행
    );
  }
}
