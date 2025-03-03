import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart'; // Home 화면 import

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후 홈 화면으로 이동
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지에 35% 투명도 적용
          Opacity(
            opacity: 0.35, // 35% 투명도
            child: Image.asset(
              'assets/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          // 로고 이미지 (투명도 없음)
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 150, // 원하는 크기로 조정 가능
            ),
          ),
        ],
      ),
    );
  }
}