import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "회원가입 유형 선택",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // 관리자 선택 버튼
            ElevatedButton(
              onPressed: () => navigateToSignUp("ADMIN"),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == "ADMIN" ? Colors.blue : Colors.grey,
                minimumSize: Size(200, 50),
              ),
              child: Text("관리자", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 20),

            // 사용자 선택 버튼
            ElevatedButton(
              onPressed: () => navigateToSignUp("USER"),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == "USER" ? Colors.blue : Colors.grey,
                minimumSize: Size(200, 50),
              ),
              child: Text("사용자", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
