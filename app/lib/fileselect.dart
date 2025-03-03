import 'package:flutter/material.dart';

import 'codeplus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FileSelectScreen(),
    );
  }
}

class FileSelectScreen extends StatefulWidget {
  @override
  _FileSelectScreenState createState() => _FileSelectScreenState();
}

class _FileSelectScreenState extends State<FileSelectScreen> {
  int _currentIndex = 0; // 네비게이션 바 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Opacity(
              opacity: 0.35, // 배경 투명도 적용
              child: Image.asset(
                'assets/background3.png', // 배경 변경
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 뒤로 가기 버튼 (왼쪽 상단)
          Positioned(
            top: 65,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF404040), size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "파일 선택" 제목
                  Text(
                    "파일 선택",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 100),

                  // 칠판 이미지 (board.png)
                  Image.asset(
                    'assets/board.png',
                    width: 350,
                    height: 160,
                    fit: BoxFit.contain, // 이미지가 크기에 맞게 조정됨
                  ),
                  SizedBox(height: 80),


                  // 원본 PDF 버튼
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE786), // 연한 노랑
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(300, 70),
                    ),
                    child: Text(
                      "원본 PDF",
                      style: TextStyle(fontSize: 22, color: Color(0xFF404040)),
                    ),
                  ),
                  SizedBox(height: 50),

                  // 요약 PDF 버튼
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE786), // 연한 노랑
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(300, 70),
                    ),
                    child: Text(
                      "요약 PDF",
                      style: TextStyle(fontSize: 22, color: Color(0xFF404040)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ✅ 하단 네비게이션 바 (기존 코드 유지)
      // 네비게이션 바
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Color(0xFF020142),
        unselectedItemColor: Colors.grey,
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
            /*case 1:
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
              break;*/
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: '코드추가'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}