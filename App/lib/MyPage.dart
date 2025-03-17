// PdfTransformScreen에서 선택한 파일명을 활용할 수 있도록 selectedPdf 매개변수를 전달하도록 설정했음

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home.dart'; // Home 화면 import
import 'codeplus.dart';
import 'pdftransform.dart'; // PdfTransformScreen 추가

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _currentIndex = 2; // '마이페이지'가 기본 선택됨
  late Future<List<Map<String, String>>> _recentRecords; // 최근 기록 목록

  @override
  void initState() {
    super.initState();
    _recentRecords = fetchRecentRecords(); // 최근 기록 데이터 가져오기
  }

  // 최근 등록한 코드 목록을 API에서 불러오기
  Future<List<Map<String, String>>> fetchRecentRecords() async {
    final response = await http.get(Uri.parse('https://your-api.com/recent-codes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((item) {
        return {
          "code": item["code"].toString(), // ✅ 명시적으로 String 변환
          "userDefinedName": item["userDefinedName"].toString(), // ✅ 명시적으로 String 변환
        };
      }).toList();
    } else {
      throw Exception('최근 기록을 불러오는 데 실패했습니다.');
    }
  }

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

                  // API 데이터를 불러오는 FutureBuilder
                  FutureBuilder<List<Map<String, String>>>(
                    future: _recentRecords,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator()); // 로딩 중
                      } else if (snapshot.hasError) {
                        return Center(child: Text("데이터를 불러오는 중 오류 발생"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("최근 등록된 코드가 없습니다."));
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Column(
                          children: snapshot.data!.map((record) {
                            return _buildRecentRecord(record["code"]!, record["userDefinedName"]!);
                          }).toList(),
                        ),
                      );
                    },
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white, // 완전히 불투명한 흰색
      selectedItemColor: Color(0xFF020142),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

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
              MaterialPageRoute(builder: (context) => MyPage()),
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: '코드추가'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }

  Widget _buildRecentRecord(String code, String userDefinedName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfTransformScreen(codeName: code), // 수정된 부분
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$code / $userDefinedName", style: TextStyle(fontSize: 18)),
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
}
