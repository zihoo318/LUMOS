import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(), // 회원가입 화면으로 변경
    );
  }
}

class SignUpScreen extends StatelessWidget {
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
                crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                children: [
                  // 회원가입 제목
                  Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040), // HEX 색상 적용
                    ),
                  ),
                  SizedBox(height: 30),

                  // 아이디 입력 필드
                  Text(
                    "아이디 *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 360,
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
                  Text(
                    "비밀번호 *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "영문, 숫자 조합 8~16자",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey, // 아이콘 색상을 연하게 설정
                        ), // 비밀번호 보기 아이콘 추가
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // 비밀번호 확인 필드
                  Text(
                    "비밀번호 확인 *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "비밀번호를 한 번 더 입력해주세요.",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey, // 아이콘 색상을 연하게 설정
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // 이름 입력 필드
                  Text(
                    "이름 *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 360,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "예) 홍길동",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 100), // 버튼을 좀 더 아래 배치

                  // 회원가입 버튼
                  Center(
                    child: Opacity(
                      opacity: 0.6, // 버튼 투명도 적용
                      child: SizedBox(
                        width: 300,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            "회원가입",
                            style: TextStyle(fontSize: 18, color: Colors.black87),
                          ),
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
