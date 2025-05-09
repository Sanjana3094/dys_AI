import 'package:flutter/material.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';
import 'reminder.dart'; // Import the reminder page

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<DateTime> calendarDays = [];

  @override
  void initState() {
    super.initState();
    _generateCalendarDays();
  }

  void _generateCalendarDays() {
    // Get the first day of current month
    final DateTime firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    // Get days to display from previous month to start with Monday
    int daysFromPreviousMonth = firstDay.weekday - 1;
    final DateTime startDate = firstDay.subtract(Duration(days: daysFromPreviousMonth));

    // Generate 35 days (5 weeks) from the start date
    calendarDays.clear();
    for (int i = 0; i < 35; i++) {
      calendarDays.add(startDate.add(Duration(days: i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8240),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        elevation: 0,
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Month Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
                      _generateCalendarDays();
                    });
                  },
                ),
                Text(
                  '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
                      _generateCalendarDays();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Calendar Grid
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Weekday Headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: weekdays.map((day) =>
                        SizedBox(
                          width: 30,
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Calendar Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: calendarDays.length,
                    itemBuilder: (context, index) {
                      final day = calendarDays[index];
                      final isCurrentMonth = day.month == selectedDate.month;
                      final isToday = day.year == DateTime.now().year &&
                          day.month == DateTime.now().month &&
                          day.day == DateTime.now().day;
                      final hasMoodEntry = _hasMoodEntry(day);

                      return GestureDetector(
                        onTap: () {
                          // Show details for this day
                          _showDayDetails(day);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isToday ? const Color(0xFF2A8240).withOpacity(0.1) : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isCurrentMonth ?
                                  (isToday ? const Color(0xFF2A8240) : Colors.black) :
                                  Colors.grey[400],
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (hasMoodEntry)
                                Positioned(
                                  bottom: 2,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A8240),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Activities for Selected Date
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Today\'s Activities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A8240),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to reminder page to add new activity
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PeriodReminderScreen()),
                            );
                          },
                          child: const Text(
                            '+ Add',
                            style: TextStyle(
                              color: Color(0xFF2A8240),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView(
                        children: const [
                          ActivityTile(
                            time: '9:00 AM',
                            title: 'Morning Meditation',
                            type: 'Relaxation',
                            isCompleted: true,
                          ),
                          ActivityTile(
                            time: '1:00 PM',
                            title: 'Mood Check-in',
                            type: 'Wellness',
                            isCompleted: true,
                          ),
                          ActivityTile(
                            time: '5:00 PM',
                            title: 'Water Plants',
                            type: 'Garden Care',
                            isCompleted: false,
                          ),
                          ActivityTile(
                            time: '8:00 PM',
                            title: 'Evening Reflection',
                            type: 'Relaxation',
                            isCompleted: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  bool _hasMoodEntry(DateTime day) {
    // Mock data - in a real app, this would check for actual entries
    final mockEntryDays = [1, 5, 10, 15, 20, 22, 25, 28];
    return day.month == DateTime.now().month && mockEntryDays.contains(day.day);
  }

  void _showDayDetails(DateTime day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getMonthName(day.month)} ${day.day}, ${day.year}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A8240),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mood: Happy',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Plants Watered: 3',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Relaxation: 15 minutes',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to reminder page from the modal
                    Navigator.pop(context); // First close the modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PeriodReminderScreen()),
                    );
                  },
                  child: const Text(
                    'Set Reminder',
                    style: TextStyle(
                      color: Color(0xFF2A8240),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A8240),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String time;
  final String title;
  final String type;
  final bool isCompleted;

  const ActivityTile({
    Key? key,
    required this.time,
    required this.title,
    required this.type,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF2A8240).withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCompleted ? const Color(0xFF2A8240).withOpacity(0.3) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF2A8240) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.access_time,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  '$type • $time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}