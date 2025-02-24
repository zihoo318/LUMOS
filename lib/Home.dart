import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'MyPage.dart'; // MyPage 화면 import
import 'codeplus.dart';

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
  Map<DateTime, List<String>> _savedFiles = {
    DateTime(2025, 2, 20): ['파일 1', '파일 2'],
    DateTime(2025, 2, 28): ['파일 1', '파일 2', '파일 3'],
  };

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
        Spacer(), // 🔹 달력 아래의 빈 공간을 최대한 활용하여 네비게이션 바 기준 고정
        Padding(
          padding: EdgeInsets.only(bottom: 45), // 🔹 네비게이션 바 기준 45px 띄움
          child: _buildFileList(),
        ),
      ],
    );
  }

  Widget _buildFileList() {
    DateTime? matchedDate = _savedFiles.keys.firstWhere(
          (date) => isSameDay(date, _selectedDay),
      orElse: () => DateTime(0), // 만약 없으면 기본값 반환
    );

    List<String> files = matchedDate.year != 0 ? _savedFiles[matchedDate] ?? [] : [];
    int fileCount = files.length; // ✅ 파일 개수 계산

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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: files
                  .map((file) => Padding(
                padding: EdgeInsets.symmetric(vertical: 7), // 파일 이름 사이 간격
                child: Text(
                  file,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ))
                  .toList(),
            ),
          ),
        ],
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
      {"name": "1주차", "image": "assets/ex_file_image1.png"},
      {"name": "2주차", "image": "assets/ex_file_image2.png"},
    ],
    "데이터마이닝": [{"name": "3주차", "image": "assets/ex_file_image1.png"}],
    "자료구조": [{"name": "4주차", "image": "assets/ex_file_image1.png"},
      {"name": "5주차", "image": "assets/ex_file_image2.png"},],
    "알고리즘": [{"name": "7주차", "image": "assets/ex_file_image1.png"}],
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
                          if (_selectedCategories.contains(category)) _buildFileList(category),
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

  Widget _buildFileList(String category) {
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
        ...files.map((file) => _buildFileItem(file)).toList(),
      ],
    );
  }

  Widget _buildFileItem(Map<String, String> file) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Row(
        children: [
          Image.asset(file["image"]!, width: 80, height: 80, fit: BoxFit.cover),
          SizedBox(width: 10),
          Text(file["name"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}