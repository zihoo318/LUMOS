import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api.dart'; // 클립보드 복사 기능 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PdfTransformScreen(codeName: '데이터베이스 1주차',),
    );
  }
}

class PdfTransformScreen extends StatefulWidget {
  final String codeName; // codeName을 받는 변수

  // 생성자에서 codeId와 codeName을 받도록 설정
  PdfTransformScreen({required this.codeName});

  @override
  _PdfTransformScreenState createState() => _PdfTransformScreenState();
}

class _PdfTransformScreenState extends State<PdfTransformScreen> {

  TextEditingController textBoxController = TextEditingController(); // 텍스트 박스 컨트롤러
  String selectedPdf = "원본 PDF"; // 기본 선택값을 원본 PDF로 설정
  String fileContent = "텍스트 로드 중..."; // 초기 텍스트
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFileText(); // 초기 로딩
  }

  // 파일 내용을 가져오는 함수
  void _loadFileText() async {
    setState(() {
      isLoading = true;
    });

    String fileName = selectedPdf == "원본 PDF" ? "test_original_txt.txt" : "test_summary_txt.txt";
    String? content = await Api.fetchFileText(fileName);

    setState(() {
      fileContent = content ?? "파일을 불러올 수 없습니다.";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/background3.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                  "📄 ${widget.codeName}", // ✅ 클릭한 파일 이름 표시
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPdf = "원본 PDF";
                          _loadFileText(); // 원본 텍스트 로드
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPdf == "원본 PDF" ? Color(0xFFFFE786) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: Text(
                        "원본 PDF",
                        style: TextStyle(color: selectedPdf == "원본 PDF" ? Colors.black : Colors.black),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPdf = "요약 PDF";
                          _loadFileText(); // 요약 텍스트 로드
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPdf == "요약 PDF" ? Color(0xFFFFE786) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: Text(
                        "요약 PDF",
                        style: TextStyle(color: selectedPdf == "요약 PDF" ? Colors.black : Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: 290,
                  height: 500,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    child: SelectableText(
                      fileContent,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: fileContent));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check, color: Colors.white),
                                SizedBox(width: 10),
                                Expanded(child: Text("전체 복사가 완료되었습니다!")),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFE786),
                        minimumSize: Size(140, 50),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.copy, color: Color(0xFF404040)),
                          SizedBox(width: 5),
                          Text("전체복사", style: TextStyle(color: Color(0xFF404040))),
                        ],
                      ),
                    ),
                    SizedBox(width: 35),
                    ElevatedButton(

                      onPressed: () async {
                        String codeName = selectedPdf == "원본 PDF" ? "test_original.pdf" : "test_summary.pdf";

                        String? filePath = await Api.downloadFile(codeName);

                        if (filePath != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("파일 다운로드 완료: $filePath")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("파일 다운로드 실패")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFE786),
                        minimumSize: Size(140, 50),
                      ),
                      child: Row(
                        children: [
                          Text("pdf다운", style: TextStyle(color: Color(0xFF404040))),
                          Icon(Icons.download, color: Color(0xFF404040)),
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