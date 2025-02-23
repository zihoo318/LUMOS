import 'package:flutter/material.dart';
import 'Home.dart';

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
      home: Home(), // Home.dart를 초기 화면으로 설정
    );
  }
}
