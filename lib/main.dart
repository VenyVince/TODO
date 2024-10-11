import 'package:flutter/material.dart';
import 'checklist.dart';
import 'nutrition.dart';
import 'static.dart';
import 'goal.dart';
import 'package:table_calendar/table_calendar.dart';
//추후에 체크리스트나 통계, 영양같은 데이터들은 데이터베이스에서 가져오게할 예정입니다. 통계파트는 좀 더 상의가 필요할 것 같아요.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedPageIndex = 0; // 현재 선택된 페이지 인덱스

  final List<Widget> _pages = [
    ChecklistPage(),
    NutritionPage(),
    StaticPage(),
    GoalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calendar'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(Icons.check_box, '체크리스트', 0),
                _buildButton(Icons.link, '영양제', 1),
                _buildButton(Icons.bar_chart, '통계', 2),
                _buildButton(Icons.flag, '목표', 3),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedPageIndex, // 현재 선택된 페이지 인덱스
              children: _pages, // 각 페이지 위젯들
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, int index) {
    return Container(
      width: 120,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedPageIndex = index; // 선택된 페이지 인덱스 업데이트
          });
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
