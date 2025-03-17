// PdfTransformScreen에서 선택한 파일명을 활용할 수 있도록 selectedPdf 매개변수를 전달하도록 설정했음

import 'package:flutter/material.dart';
import 'api.dart';
import 'home.dart'; // Home 화면 import
import 'codeplus.dart';
import 'login.dart';
import 'pdftransform.dart'; // PdfTransformScreen 추가

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _currentIndex = 2; // '마이페이지'가 기본 선택됨

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱바 추가 (뒤로가기 포함)
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 앱바 배경 투명
        elevation: 0, // 그림자 제거
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "마이페이지",
          style: TextStyle(
            fontSize: 22, // 글씨 크기 증가
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true, // 중앙 정렬
      ),
      extendBodyBehindAppBar: true, // 앱바가 배경 위에 올라가도록 설정

      body: Stack(
        children: [
      // 배경 이미지
      Positioned.fill(
      child: Opacity(
      opacity: 0.35, // 투명도 35%
        child: Image.asset(
          'assets/background1.png',
          fit: BoxFit.cover,
        ),
      ),
    ),
    // 컨텐츠
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20), // 앱바와 겹치지 않도록 여백 추가

                  // "최근 기록" 제목 (왼쪽에서 15만큼 띄우기)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "최근 기록",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20), // 최근 기록 텍스트와 리스트 사이 여백

                  // 최근 기록 리스트 (왼쪽 간격 조정)
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Column(
                      children: [
                        _buildRecentRecord(context, "CS101-ABCD"),
                        _buildRecentRecord(context, "DB103-AEHS"),
                        _buildRecentRecord(context, "CR302-PAFS"),
                        _buildRecentRecord(context, "CR302-BDFE"),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "계정관리",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      _buildAccountOption("로그아웃", _logout),
                        _buildAccountOption("회원탈퇴", _showDeleteConfirmDialog),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // 네비게이션 바
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // 투명도 60% 적용
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // 바탕 자체는 투명
          selectedItemColor: Color(0xFF020142), // 선택된 아이콘 남색
          unselectedItemColor: Colors.grey, // 비활성 아이콘 회색
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // 선택한 탭에 맞는 페이지로 이동
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CodeInputScreen()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()), // 현재 페이지
                );
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '코드추가',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }

void _logout() async {
  await Api.logout(); // ✅ 올바르게 API 호출
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

  void _deleteAccount() async {
    Map<String, dynamic> result = await Api.deleteAccount();

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
      );

      await Future.delayed(Duration(seconds: 1)); // ✅ 1초 후 이동
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false, // ✅ 모든 기존 화면 제거
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? '회원탈퇴 실패')));
    }
  }



  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // ✅ 다이얼로그의 새로운 context 저장
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              "정말로 회원탈퇴를 하시겠습니까?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFE786),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // ✅ 다이얼로그 먼저 닫기
                    Future.delayed(Duration(milliseconds: 200), () { // ✅ 딜레이 후 회원탈퇴 실행
                      _deleteAccount();
                    });
                  },
                  child: Text("예", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text("취소", style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountOption(String title, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    ),
  );
}
}
Widget _buildRecentRecord(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context, // ✅ 오류 해결: 매개변수로 받은 context 사용
        MaterialPageRoute(
          builder: (context) => PdfTransformScreen(codeName: title),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18)),
          SizedBox(height: 3),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 270,
              child: Divider(color: Colors.black, thickness: 1),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFileItem(BuildContext context, Map<int, String> file) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfTransformScreen(codeName: file["name"]!), // ✅ 클릭한 파일명 전달
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Row(
        children: [
          Text(
            file["name"]!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

// 계정 관리 옵션 위젯 (클릭 가능하도록 변경)
Widget _buildAccountOption(String title, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // 클릭 시 실행될 함수
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    ),
  );
}
