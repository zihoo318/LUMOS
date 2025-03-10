import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'MyPage.dart'; // MyPage 화면 import
import 'SharedPreferencesManager.dart';
import 'api.dart';
import 'codeplus.dart';
import 'pdftransform.dart'; // ✅ PDF 변환 화면 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(), // Home 위젯 실행
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("홈 화면")),
    );
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 1; // 현재 선택된 인덱스 (기본값: 홈)
  bool _isCategoryView = false; // ✅ 날짜별 & 카테고리별 전환 여부

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.35,
                    child: Image.asset(
                      'assets/background2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 50),
                    // ✅ '날짜별' 또는 '카테고리별' 화면 제목
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_left),
                          onPressed: () {
                            setState(() {
                              _isCategoryView = false;
                            });
                          },
                        ),
                        Text(
                          _isCategoryView ? "카테고리별" : "날짜별",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_right),
                          onPressed: () {
                            setState(() {
                              _isCategoryView = true;
                            });
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: _isCategoryView ? CategoryView() : CalendarView(),
                    ),
                  ],
                ),
              ],
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

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _savedFiles = {};

  // 날짜 선택 시 API 호출하여 파일 목록 가져오기
  Future<void> fetchFiles(String date) async {
    if (_savedFiles.containsKey(DateTime.parse(date))) {
      print("이미 가져온 데이터: $date");
      return; // 이미 가져온 데이터라면 추가 요청 X
    }
    print("API 요청 시작 - 날짜: $date");
    String? userName = await SharedPreferencesManager.getUserName(); // 유저 이름 가져오기

    if (userName == null) {
      print("로그인이 필요합니다.");
      return;
    }

    List<String> files = await Api.getFilesByDate(date, userName);
    setState(() {
      _savedFiles[DateTime.parse(date)] = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("${_focusedDay.year}.${_focusedDay.month.toString().padLeft(2, '0')}"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              // ✅ 날짜 선택 시 API 호출
              fetchFiles("${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}");
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 45),
          child: _buildFileList(context), // ✅ context를 전달해야 함
        ),
      ],
    );
  }

  Widget _buildFileList(BuildContext context) {
    DateTime? matchedDate = _savedFiles.keys.firstWhere(
          (date) => isSameDay(date, _selectedDay),
      orElse: () => DateTime(0),
    );

    List<String> files = matchedDate.year != 0 ? _savedFiles[matchedDate] ?? [] : [];
    int fileCount = files.length;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 330,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10, top: 5),
              child: Text(
                "$fileCount files",
                style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: files.map((file) => _buildFileItem(context, file)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, String fileName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfTransformScreen(fileName: fileName), // ✅ 파일명 전달
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Text(
          fileName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  Set<String> _selectedCategories = {}; // ✅ 여러 개의 카테고리를 선택 가능하도록 변경
  Map<String, List<Map<String, String>>> _categoryFiles = {
    "데이터베이스": [
      {"name": "1주차"},
      {"name": "2주차"},
    ],
    "데이터마이닝": [{"name": "3주차"}],
    "자료구조": [{"name": "4주차"},
      {"name": "5주차"}],
    "알고리즘": [{"name": "7주차"}],
  };

  List<String> _categories = ["데이터베이스", "데이터마이닝", "자료구조", "알고리즘"];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double boxHeight = screenHeight - 180 - kBottomNavigationBarHeight; // ✅ 세로 길이를 실제로 줄임

    return Column(
      children: [
        SizedBox(height: 35), //상단바와 박스 사이 여백
        SizedBox(
          height: boxHeight,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.83,
              height: boxHeight,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "${_categories.length} categories",
                      style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _categories.expand((category) => [
                          _buildCategoryButton(category),
                          if (_selectedCategories.contains(category))
                            _buildFileList(context, category),
                        ]).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (_selectedCategories.contains(title)) {
                _selectedCategories.remove(title); // ✅ 이미 열려 있으면 닫음
              } else {
                _selectedCategories.add(title); // ✅ 추가 선택 가능
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFE786),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileList(BuildContext context, String category) {
    List<Map<String, String>> files = _categoryFiles[category] ?? [];
    return Column(
      children: [
        SizedBox(height: 10),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            "${files.length} files",
            style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        ...files.map((file) => _buildFileItem(context, file)).toList(), // ✅ context 추가
      ],
    );
  }



  Widget _buildFileItem(BuildContext context, Map<String, String> file) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfTransformScreen(fileName: file["name"]!), // ✅ 클릭한 파일명 전달
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


}