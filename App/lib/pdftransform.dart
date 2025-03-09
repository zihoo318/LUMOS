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
  TextEditingController textBoxController = TextEditingController(); // 텍스트 박스 컨트롤러
  String selectedPdf = "원본 PDF"; // 기본 선택값을 원본 PDF로 설정

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPdf = "원본 PDF";
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
                  child: selectedPdf == "원본 PDF"
                      ? Image.asset('assets/original_pdf.png', fit: BoxFit.cover)
                      : Image.asset('assets/summary_pdf.png', fit: BoxFit.cover),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: textBoxController.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("텍스트가 복사되었습니다!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFE786),
                        minimumSize: Size(140, 50),
                      ),
                      child: Text("전체복사", style: TextStyle(color: Color(0xFF404040))),
                    ),
                    SizedBox(width: 35),
                    ElevatedButton(
                      onPressed: () {},
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