import 'package:flutter/material.dart';
import 'home.dart'; // Home 화면 import

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
            fontSize: 23, // 글씨 크기 증가
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
                    padding: const EdgeInsets.only(left: 70), // 왼쪽 간격 조정
                    child: Column(
                      children: [
                        _buildRecentRecord("CS101-ABCD"),
                        _buildRecentRecord("DB103-AEHS"),
                        _buildRecentRecord("CR302-PAFS"),
                        _buildRecentRecord("CR302-BDFE"),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // "계정관리" 제목 (왼쪽에서 15만큼 띄우기)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "계정관리",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20), // 계정관리 텍스트와 옵션 사이 여백

                  // 계정관리 옵션 위치 조정 (왼쪽 간격 조정)
                  Padding(
                    padding: const EdgeInsets.only(left: 75), // 왼쪽 간격 조정
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAccountOption("로그아웃", () {
                          print("로그아웃 버튼 클릭됨");
                          // 여기에 로그아웃 기능 추가할 것
                        }),
                        _buildAccountOption("회원탈퇴", () {
                          print("회원탈퇴 버튼 클릭됨");
                          // 여기에 회원탈퇴 기능 추가할 것
                        }),
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
              /*case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCodePage()),
                );
                break;*/
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

  // 최근 기록 위젯 (밑줄 길이 75%로 조정 + 정렬)
  Widget _buildRecentRecord(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
        children: [
          Text(title, style: TextStyle(fontSize: 18)), // 글씨 크기 키움
          SizedBox(height: 3), // 텍스트와 밑줄 사이 간격 조정
          Align(
            alignment: Alignment.centerLeft, // 왼쪽 정렬
            child: SizedBox(
              width: 270, // 밑줄 고정된 길이로 설정
              child: Divider(color: Colors.black, thickness: 1),
            ),
          ),
        ],
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
}
