import 'package:flutter/material.dart';
import 'SplashScreen.dart'; // SplashScreen (스플래시 화면) import
import 'home.dart'; // Home 화면 import
import 'MyPage.dart'; // MyPage 화면 import
import 'package:lumos/pdftransform.dart';
import 'package:lumos/signup.dart';
import 'codeplus.dart';
import 'fileselect.dart';
import 'login.dart';


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
