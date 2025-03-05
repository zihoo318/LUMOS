import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart'; // JSON 변환을 위해 필요


class SignUpScreen extends StatefulWidget {
  final String role; // 역할을 전달받음
  SignUpScreen({required this.role});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 입력 필드 컨트롤러
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // 백엔드 API 주소
  final String apiUrl = "http://172.16.28.155:8080/api/users/register";

  // 비밀번호 검증 함수 (영어 + 숫자 조합, 8~16자)
  bool validatePassword(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$');
    return passwordRegex.hasMatch(password);
  }

  // 이메일 검증 함수 (일반적인 이메일 형식 확인)
  bool validateEmail(String email) {
    final RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // 회원가입 요청 함수
  Future<void> signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
      );
      return;
    }

    if (!validatePassword(passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("비밀번호는 영문 + 숫자 조합 8~16자로 입력하세요.")),
      );
      return;
    }

    if (!validateEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("올바른 이메일 형식을 입력하세요.")),
      );
      return;
    }

    Map<String, dynamic> requestBody = {
      "username": usernameController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "role": widget.role,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("회원가입 성공!")),
        );

        // 회원가입 성공 시 로그인 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

      } else {
        // 응답 본문이 메시지일 경우
        String message = utf8.decode(response.bodyBytes);  // 서버에서 전달된 오류 메시지
        print("응답 메시지: $message");  // 응답 메시지 출력
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류가 발생했습니다. 다시 시도해주세요.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 30),

                  // 아이디 입력 필드
                  Text("아이디 *"),
                  SizedBox(height: 10),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "아이디 입력",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  // 비밀번호 입력 필드
                  Text("비밀번호 *"),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "영문 + 숫자 조합 8-16자 이내",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  // 비밀번호 확인
                  Text("비밀번호 확인 *"),
                  SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "비밀번호 재입력",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  // 이메일 입력
                  Text("이메일 *"),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "이메일 입력",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  SizedBox(height: 50),

                  // 회원가입 버튼
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: signUp, // 버튼 클릭 시 signUp() 함수 실행
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "회원가입",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
