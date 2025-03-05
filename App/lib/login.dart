import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumos/signupStart.dart';
import 'dart:convert';
import 'signup.dart';
import 'SharedPreferencesManager.dart';

void main() {
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

  Future<void> login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // 로그인 API 호출
    final response = await http.post(
      Uri.parse('http://172.16.28.155:8080/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // 로그인 성공 시, 처리
      final data = json.decode(response.body);
      print('로그인 성공: ${data}');
      // 이후 화면 이동 등의 작업
      await SharedPreferencesManager.saveUserName(username);
    } else {
      // 로그인 실패 시, 오류 처리
      final errorMessage = response.body; // 오류 메시지 받기
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
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
                        onPressed: login,
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