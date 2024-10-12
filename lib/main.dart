import 'package:flutter/material.dart';
import 'checklist.dart';
import 'nutrition.dart';
import 'static.dart';
import 'goal.dart';
import 'package:table_calendar/table_calendar.dart';
// 추후에 체크리스트나 통계, 영양 같은 데이터들은 데이터베이스에서 가져오게 할 예정입니다.

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
  int _selectedPageIndex = 0; // 현재 선택된 페이지

  // 날짜별 데이터를 저장하는 Map
  Map<DateTime, Map<String, dynamic>> _dateData = {
    DateTime.utc(2024, 10, 1): {
      'checklist': ['운동하기', '영양제 복용'],
      'nutrition': {'칼로리': 2200, '단백질': 150},
      'goal': '5km 달리기',
    },
    DateTime.utc(2024, 10, 2): {
      'checklist': ['스트레칭', '물 2L 마시기'],
      'nutrition': {'칼로리': 1800, '단백질': 130},
      'goal': '책 30페이지 읽기',
    },
  };

  // 선택된 날짜의 데이터를 저장하는 변수
  Map<String, dynamic> _currentData = {}; //데이터베이스 연동시 해당 날짜의 데이터를 가져와 _currentData에 저장
                                          //line58에 추가.
  @override
  void initState() {
    super.initState();
    _loadDataForSelectedDay(_focusedDay); // 앱이 실행될 때 현재 날짜에 해당하는 데이터를 로드
  }

  // 날짜 선택 시 데이터를 불러오는 함수
  void _loadDataForSelectedDay(DateTime selectedDay) {
    setState(() {
      _currentData = _dateData[selectedDay] ?? { //요기!
        'checklist': ['데이터 없음'],
        'nutrition': {'칼로리': 0, '단백질': 0},
        'goal': '목표 없음',
      };
    });
  }

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
                      _loadDataForSelectedDay(selectedDay); // 날짜 선택 시 데이터 로드
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
              children: [
                _buildChecklistPage(),
                _buildNutritionPage(),
                StaticPage(),
                _buildGoalPage(),
              ],
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

  // 체크리스트 페이지
  Widget _buildChecklistPage() {
    List<String> checklist = _currentData['checklist'] ?? ['데이터 없음'];
    return ListView.builder(
      itemCount: checklist.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(checklist[index]),
        );
      },
    );
  }

  // 영양 페이지
  Widget _buildNutritionPage() {
    Map<String, int> nutrition = _currentData['nutrition'] ?? {'칼로리': 0, '단백질': 0};
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('칼로리: ${nutrition['칼로리']} kcal'),
        Text('단백질: ${nutrition['단백질']} g'),
      ],
    );
  }

  // 목표 페이지
  Widget _buildGoalPage() {
    String goal = _currentData['goal'] ?? '목표 없음';
    return Center(
      child: Text('오늘의 목표: $goal'),
    );
  }
}
