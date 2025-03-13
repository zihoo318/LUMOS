import 'package:flutter/material.dart';
import 'Home.dart';
import 'MyPage.dart';
import 'api.dart';
import 'SharedPreferencesManager.dart';

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
  int _currentIndex = 0; // 현재 선택된 인덱스
  final TextEditingController _codeController = TextEditingController(); // 코드 입력 필드 컨트롤러

  final TextEditingController _codeNameController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  List<String> categories = []; // 카테고리 목록
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories(); // SharedPreferences에서 카테고리 목록 불러오기
  }

  // 카테고리 목록 불러오기
  Future<void> _loadCategories() async {
    try {
      // SharedPreferences에서 카테고리 목록을 가져옴
      List<String> fetchedCategories = await SharedPreferencesManager.getAllCategoryNames();
      setState(() {
        categories = fetchedCategories; // 가져온 카테고리 목록 업데이트
        print(categories);
      });
    } catch (e) {
      print("카테고리 로드 오류: $e");
    }
  }

  // ✅ 1. 파일명 입력 팝업
  void _showCodeNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 팝업 모서리 둥글게
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("코드 이름 설정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _codeNameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "코드 이름 입력",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String codeName = _codeNameController.text.trim(); // 입력값 가져오기
                    if (codeName.isNotEmpty) {
                      try {
                        String response = await Api.setCodeNameForRegister(codeName);
                        print("API 응답: $response");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("별명 등록 완료!")),
                        );
                      } catch (e) {
                        print("API 오류: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("별명 등록 실패!")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("코드 이름을 입력해주세요!")),
                      );
                      return;
                    }
                    _codeNameController.clear();
                    Navigator.pop(context);
                    _showCategoryDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD966), // 노란색 버튼
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("저장", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// ✅ 2. 카테고리 선택 팝업 (위치 변화 없이 유지)
  void _showCategoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // ✅ 외부 터치로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 팝업 모서리 둥글게
          ),
          insetPadding: EdgeInsets.zero, // ✅ 팝업이 뜰 때 UI 변화 방지
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // 내부 패딩 조절
          title: Center(
            child: Text(
              "어떤 카테고리에 넣을까요?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 카테고리가 비어 있지 않다면 버튼을 생성
                if (categories.isNotEmpty)
                  Column(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5), // 버튼 간격 조절
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            Navigator.pop(context);
                            _saveCodeToCategory();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFE786), // 노란 버튼
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fixedSize: Size(200, 45), // 버튼 크기 조절
                          ),
                          child: Text(category, style: TextStyle(color: Color(0xFF404040))),
                        ),
                      );
                    }).toList(),
                  ),
                if (categories.isEmpty)
                  Text(
                    "저장된 카테고리가 없습니다.",
                    style: TextStyle(color: Colors.black45),
                  ),
                SizedBox(height: 20),
                Divider(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showNewCategoryDialog(); // 새로운 카테고리 추가 팝업
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("+ 새로운 카테고리", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // ✅ 3. 새로운 카테고리 추가 팝업
  // ✅ 카테고리 추가 팝업 (디자인 개선)
  void _showNewCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // 팝업 모서리 둥글게
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("카테고리", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _newCategoryController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "카테고리 입력",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_newCategoryController.text.isNotEmpty) {
                      setState(() {
                        categories.add(_newCategoryController.text); // ✅ 카테고리 추가
                      });

                      try {
                        String categoryName = _newCategoryController.text;
                        // API 호출하여 새로운 카테고리 생성
                        final api = Api();
                        Map<String, dynamic> response = await api.createCategory(categoryName);


                        if (response.containsKey('message')) {
                          setState(() {
                            _loadCategories();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("카테고리 등록 완료!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("카테고리 등록 실패: ${response['error']}")),
                          );
                        }
                      } catch (e) {
                        print("API 오류: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("카테고리 등록 중 오류 발생")),
                        );
                      }

                      _newCategoryController.clear();
                      Navigator.pop(context);
                      _showCategoryDialog(); // ✅ 다시 카테고리 선택 팝업 표시
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD966), // 노란색 버튼
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("저장", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  // 카테고리에 코드 저장 api
  void _saveCodeToCategory() async {
    String code = _codeController.text;
    String category = selectedCategory ?? "";

    if (code.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('코드와 카테고리를 선택해 주세요.')),
      );
      return;
    }

    // 카테고리 이름으로 id찾기
    int categoryId = await SharedPreferencesManager.getCategoryIdByName(category) ??
        (throw Exception('해당 카테고리를 찾을 수 없습니다.'));

    // API 호출: 코드와 카테고리 정보를 서버로 전송
    var result = await Api.addCodeToCategory(categoryId);

    if (result != null && result['success'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('코드가 카테고리에 성공적으로 추가되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('코드 추가에 실패했습니다.')),
      );
    }
  }


  // 코드 등록 API 호출 함수
  void _registerCode() async {
    String code = _codeController.text;
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('코드를 입력해 주세요.')),
      );
      return;
    }

    try {
      var result = await Api.registerCode(code);
      print("🔥 API 응답: $result"); // ✅ API 응답 값 로그 확인

      if (result.containsKey('registerId')) {
        String registerId = result['registerId'];
        print("✅ 등록된 Register ID: $registerId");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 성공! Register ID: $registerId')),
        );

        if (mounted) {
          setState(() {
            _showCodeNameDialog();
          });
        }
      } else {
        String errorMessage = result['error'] ?? '알 수 없는 오류 발생';
        print("❌ API 오류: $errorMessage");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $errorMessage')),
        );
      }
    } catch (e) {
      print("🚨 API 호출 중 예외 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API 호출 중 오류 발생! $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/background3.png',
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
                  Text(
                    "코드입력",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  SizedBox(height: 60),

                  // 코드 입력 필드
                  SizedBox(
                    width: 330,
                    child: TextField(
                      controller: _codeController,
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
                    onPressed: _registerCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE786),
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


