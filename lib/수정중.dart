/*
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'MyPage.dart'; // MyPage 화면 import

class Home extends StatefulWidget {
  @override
  _HomeCalendarState createState() => _HomeState();
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // 투명도 60% 적용
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // 바탕 자체는 투명
          selectedItemColor: Color(0xFF020142), // 선택된 아이콘 남색
          unselectedItemColor: Colors.grey, // 비활성 아이콘 회색
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // 선택한 탭에 맞는 페이지로 이동
            switch (index) {
            */
/*case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddCodePage()),
                );
                break;*//*

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
}*/
