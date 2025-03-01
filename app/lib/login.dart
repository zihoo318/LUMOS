import 'package:flutter/material.dart';

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

class LoginScreen extends StatelessWidget {
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
                      decoration: InputDecoration(
                        hintText: "예) abc",
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
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "영문, 숫자 조합 8~16자",
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
                        onPressed: () {},
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
                        onPressed: () {},
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
