import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart'; // 회원가입 화면 import

class SignUpStart extends StatefulWidget {
  @override
  _SignUpStartState createState() => _SignUpStartState();
}

class _SignUpStartState extends State<SignUpStart> {
  String selectedRole = ""; // 선택한 역할 저장 ("" 초기값)

  void navigateToSignUp(String role) {
    setState(() {
      selectedRole = role;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(role: role), // 역할 전달
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지 (투명도 32%)
          Opacity(
            opacity: 0.32,
            child: Image.asset(
              'assets/background1.png',
              fit: BoxFit.cover,
            ),
          ),



          // 🔹 왼쪽 상단 뒤로 가기 버튼 추가
          Positioned(
            top: 40, // 상단 여백 (상태바 고려)
            left: 16, // 왼쪽 여백
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87, size: 28), // 뒤로 가기 아이콘
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // login.dart의 LoginScreen()으로 이동
                );
              },
            ),
          ),





          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 상단 아이콘 이미지 (board.png)
                Image.asset(
                  'assets/board.png',
                  width: 160, // 크기 키우기
                  height: 160,
                  fit: BoxFit.contain, // 이미지가 크기에 맞게 조정됨
                ),
                SizedBox(height: 70),

                // 사용자 버튼
                ElevatedButton(
                  onPressed: () => navigateToSignUp("USER"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.6), // 투명도 60%
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 코너 반경 30
                      side: BorderSide(width: 1, color:  Colors.black87), // Stroke Weight 1 적용
                    ),
                    minimumSize: Size(250, 60),
                    elevation: 0, // 그림자 제거
                  ),
                  child: Text(
                    "사용자",
                    style: TextStyle(fontSize: 18, color:  Colors.black87),
                  ),
                ),
                SizedBox(height: 40),

                // 관리자 버튼
                ElevatedButton(
                  onPressed: () => navigateToSignUp("ADMIN"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.6), // 투명도 60%
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 코너 반경 30
                      side: BorderSide(width: 1, color:  Colors.black87), // Stroke Weight 1 적용
                    ),
                    minimumSize: Size(250, 60),
                    elevation: 0, // 그림자 제거
                  ),
                  child: Text(
                    "관리자",
                    style: TextStyle(fontSize: 18, color:  Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
