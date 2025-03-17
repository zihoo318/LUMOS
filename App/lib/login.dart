import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumos/signupStart.dart';
import 'dart:convert';
import 'Home.dart';
import 'api.dart';
import 'signup.dart';
import 'SharedPreferencesManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await Firebase.initializeApp(); // Firebase 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // FCM 토큰 가져오기
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final response = await Api.login(username, password, fcmToken ?? "");

    print("서버 응답: ${jsonEncode(response)}");

    if (response.containsKey('username')) {  // 로그인 성공
      print('로그인 성공: ${response['username']}');

      // 기존 SharedPreferences 데이터 초기화
      await SharedPreferencesManager.clearAll();

      // 사용자 이름 저장
      await SharedPreferencesManager.saveUserName(response['username']);

      // 홈 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      // 로그인 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'] ?? "로그인 실패")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Opacity(
              opacity: 0.6, // 배경 투명도 적용
              child: Image.asset(
                'assets/background1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 상단 로고 이미지 (크기 키우기 & 공간 고정)
                  SizedBox(
                    height: 200, // 고정 높이 설정 (밀리지 않도록)
                    child: Image.asset(
                      'assets/board.png',
                      width: 180, // 크기 키우기
                      height: 180,
                      fit: BoxFit.contain, // 이미지가 크기에 맞게 조정됨
                    ),
                  ),
                  SizedBox(height: 30),


                  // 아이디 입력 필드
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "아이디 *",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF404040), // HEX 코드 적용
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 360, // 입력 필드 너비 줄이기
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "아이디",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // 비밀번호 입력 필드
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "비밀번호 *",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 360, // 입력 필드 너비 줄이기
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "비밀번호",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 100), // 버튼을 좀 더 아래 배치

                  // 로그인 버튼
                  Opacity(
                    opacity: 0.6, // 버튼 투명도 적용
                    child: SizedBox(
                      width: 280, // 버튼 크기 조정
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "로그인",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // 회원가입 버튼
                  Opacity(
                    opacity: 0.6, // 버튼 투명도 적용
                    child: SizedBox(
                      width: 280, // 버튼 크기 조정
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpStart()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "회원가입",
                          style: TextStyle(fontSize: 18, color:Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}