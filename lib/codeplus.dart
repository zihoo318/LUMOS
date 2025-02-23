import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CodeInputScreen(),
    );
  }
}

class CodeInputScreen extends StatefulWidget {
  @override
  _CodeInputScreenState createState() => _CodeInputScreenState();
}

class _CodeInputScreenState extends State<CodeInputScreen> {
  int _currentIndex = 0; // 현재 선택된 인덱스 (기본값: 코드 추가)

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

          // 뒤로 가기 버튼 (왼쪽 상단으로 이동)
          Positioned(
            top: 65, // 화면 상단 여백 조절
            left: 10, // 왼쪽 정렬
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
                  SizedBox(height: 10), // 상단 여백 추가

                  // "코드 입력" 텍스트
                  Text(
                    "코드입력",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040), // 연한 검정색
                    ),
                  ),
                  SizedBox(height: 60),

                  // 코드 입력 필드
                  SizedBox(
                    width: 330,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),

                  // 확인 버튼
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE786), // 연한 노랑 계열
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(200, 60),
                    ),
                    child: Text(
                      "확인",
                      style: TextStyle(fontSize: 25, color: Color(0xFF404040)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // ✅ 투명한 흰색 적용
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect( // ✅ 네비게이션 바의 모서리를 둥글게 잘라 자연스럽게 만듦
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            elevation: 0, // ✅ 그림자 제거 (회색 효과 방지)
            selectedItemColor: Color(0xFF020142), // 선택된 아이콘과 글씨 남색
            unselectedItemColor: Colors.grey, // 비활성 아이콘 회색
            currentIndex: _currentIndex, // 현재 선택된 아이콘 반영
            onTap: (index) {
              setState(() {
                _currentIndex = index; // 선택된 탭 변경
              });
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
      ),

    );
  }
}
