import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 클립보드 복사 기능 추가
import 'Home.dart';
import 'MyPage.dart';
import 'api.dart';

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
  final TextEditingController _codeController = TextEditingController();  // 코드 입력 필드 컨트롤러
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  List<String> categories = ["데이터분석", "과제자료", "개인파일"];
  String selectedCategory = "";

  // API 호출 함수
  void _registerCode() async {
    String code = _codeController.text;

    // 입력된 코드가 비어있으면 경고 메시지
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('코드를 입력해 주세요.')),
      );
      return;
    }

    // API 호출
    var result = await Api.registerCode(code);

    // 결과 처리
    if (result.containsKey('registerId')) {
      String registerId = result['registerId'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록 성공! Register ID: $registerId')),
      );
    } else if (result.containsKey('error')) {
      String error = result['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $error')),
      );
    }
  }

  // 코드 입력 후 파일명 팝업
  void _showFileNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("파일명 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _fileNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "파일명을 입력하세요",
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCategoryDialog(); // 파일명 입력 후 카테고리 선택 팝업
                  },
                  child: Text("다음"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 카테고리 선택 팝업
  void _showCategoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Center(child: Text("어떤 카테고리에 넣을까요?")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(category),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAddCategoryDialog();
                },
                child: Text("+ 새로운 카테고리 추가", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );
      },
    );
  }

  // 새로운 카테고리 추가 팝업
  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("새로운 카테고리 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "새로운 카테고리 입력",
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_categoryController.text.isNotEmpty) {
                      setState(() {
                        categories.add(_categoryController.text);
                      });
                      _categoryController.clear();
                      Navigator.pop(context);
                      _showCategoryDialog();
                    }
                  },
                  child: Text("저장"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                      controller: _codeController, // 컨트롤러 연결
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
                    onPressed: _registerCode, // API 호출 함수 연결
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
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: '코드추가'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}