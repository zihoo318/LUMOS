import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 클립보드 복사 기능 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PdfTransformScreen(),
    );
  }
}

class PdfTransformScreen extends StatefulWidget {
  @override
  _PdfTransformScreenState createState() => _PdfTransformScreenState();
}

class _PdfTransformScreenState extends State<PdfTransformScreen> {
  List<String> categories = ["데이터분석", "과제자료", "개인파일"]; // 카테고리 리스트
  String selectedCategory = ""; // 선택된 카테고리
  TextEditingController categoryController = TextEditingController(); // 카테고리 입력 컨트롤러
  TextEditingController fileNameController = TextEditingController(); // 파일명 입력 컨트롤러
  TextEditingController textBoxController = TextEditingController(); // 텍스트 박스 컨트롤러

  // ✅ 1. 텍스트 복사 기능
  void _copyText() {
    if (textBoxController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: textBoxController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("텍스트가 복사되었습니다!")),
      );
    }
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
          content: SizedBox( // ✅ 크기 고정하여 UI 변화 방지
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: categories.map((category) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        Navigator.pop(context);
                        _showFileNameDialog(); // ✅ 파일명 저장 팝업 표시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFE786), // 노란 버튼
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(category, style: TextStyle(color: Color(0xFF404040))),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Divider(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showAddCategoryDialog(); // ✅ 새로운 카테고리 추가 팝업
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
  void _showAddCategoryDialog() {
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
                  controller: categoryController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "카테고리 입력",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (categoryController.text.isNotEmpty) {
                      setState(() {
                        categories.add(categoryController.text); // ✅ 카테고리 추가
                      });
                      categoryController.clear();
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

  // ✅ 4. 파일명 입력 팝업
  void _showFileNameDialog() {
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
              Text("파일명", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: fileNameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "파일명 입력",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    fileNameController.clear();
                    Navigator.pop(context);
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

          // 뒤로 가기 버튼
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "원본 PDF 파일 변환",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF404040),
                  ),
                ),
                SizedBox(height: 90),

                // ✅ 텍스트 박스 (입력 가능)
                Container(
                  width: 290,
                  height: 500,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: textBoxController,
                    maxLines: null,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 80),

                // ✅ 전체복사 & PDF 다운로드 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _copyText, // ✅ 텍스트 복사 기능 실행
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFE786), // 연한 노랑
                        minimumSize: Size(140, 50),
                      ),
                      child: Text("전체복사", style: TextStyle(color: Color(0xFF404040),)),
                    ),
                    SizedBox(width: 35),
                    ElevatedButton(
                      onPressed: _showCategoryDialog, // ✅ PDF 다운로드 팝업 실행
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFE786), // 연한 노랑,
                        minimumSize: Size(140, 50),
                      ),
                      child: Row(
                        children: [
                          Text("pdf다운", style: TextStyle(color: Color(0xFF404040),)),
                          Icon(Icons.download, color: Color(0xFF404040),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
