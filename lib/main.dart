import 'package:flutter/material.dart';
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
      home: LoginScreen(), // Home_calendar.dart를 초기 화면으로 설정
    );
  }
}