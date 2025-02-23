import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  @override
  _HomeCalendarState createState() => _HomeCalendarState();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("홈 화면")),
    );
  }
}

class _HomeCalendarState extends State<Home> {
  int _currentIndex = 0; // 현재 선택된 인덱스 (기본값: 코드 추가)
  bool _isCategoryView = false; // ✅ 날짜별 & 카테고리별 전환 여부
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _savedFiles = {
    DateTime(2025, 2, 20): ['파일 1', '파일 2', '파일 3'],
    DateTime(2025, 2, 28): ['파일 1', '파일 2', '파일 3', '파일 4'],
  };
  List<String> _categories = ["데이터베이스", "데이터마이닝", "자료구조", "알고리즘"]; // ✅ 카테고리 리스트

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
                    opacity: 0.6,
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
                    if (!_isCategoryView) _buildCalendarView(),
                    if (_isCategoryView) _buildCategoryView(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // 완전 투명하지 않은 흰색 (투명도 60%)
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // 네비게이션 바 자체는 투명
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
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        Text(
          "${_focusedDay.year}.${_focusedDay.month.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: CalendarFormat.month,
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
        SizedBox(height: 20),
        _buildFileList(),
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
      height: 336,
      margin: EdgeInsets.only(top: 30, bottom: 30),
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
                padding: EdgeInsets.symmetric(vertical: 5),
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

  Widget _buildCategoryView() {
    int categoryCount = _categories.length; // ✅ 카테고리 개수 계산
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10, top: 5),
                  child: Text(
                    "$categoryCount categories",
                    style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ..._categories.map((category) => _buildCategoryButton(category)).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(title, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}