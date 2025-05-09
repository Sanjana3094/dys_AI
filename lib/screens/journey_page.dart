import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_page.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({Key? key}) : super(key: key);

  @override
  _JourneyPageState createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  // Sample data for journey entries
  final List<JourneyEntry> _journeyEntries = [
    JourneyEntry(
      date: DateTime.now().subtract(const Duration(days: 0)),
      mood: 'Happy',
      activities: ['Meditation', 'Hydration'],
      plantProgress: 0.9,
      notes: 'Today was a great day! I felt energized and accomplished a lot.',
    ),
    JourneyEntry(
      date: DateTime.now().subtract(const Duration(days: 1)),
      mood: 'Neutral',
      activities: ['Breathing Exercise'],
      plantProgress: 0.8,
      notes: 'Felt mostly balanced today. Had a minor headache in the afternoon.',
    ),
    JourneyEntry(
      date: DateTime.now().subtract(const Duration(days: 2)),
      mood: 'Sad',
      activities: ['Journaling'],
      plantProgress: 0.7,
      notes: 'Had a difficult day with some stress. Took time to journal my feelings.',
    ),
    JourneyEntry(
      date: DateTime.now().subtract(const Duration(days: 4)),
      mood: 'Happy',
      activities: ['Meditation', 'Walking'],
      plantProgress: 0.6,
      notes: 'Beautiful day outside! The walk definitely improved my mood.',
    ),
    JourneyEntry(
      date: DateTime.now().subtract(const Duration(days: 7)),
      mood: 'Angry',
      activities: ['Breathing Exercise', 'Hydration'],
      plantProgress: 0.4,
      notes: 'Frustrated with work deadlines. The breathing exercises helped calm me down.',
    ),
    JourneyEntry(
      date: DateTime.now().subtract(const Duration(days: 9)),
      mood: 'Neutral',
      activities: ['Reading', 'Meditation'],
      plantProgress: 0.3,
      notes: 'Spent time reading a new book on mindfulness. Feeling contemplative.',
    ),
  ];

  // Filter options
  String _selectedTimeframe = 'All Time';
  final List<String> _timeframes = ['Last Week', 'Last Month', 'All Time'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E7D2), // Light green background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        elevation: 0,
        title: const Text(
          'Your Journey',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Section with Plants (clickable to calendar page)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CalendarPage()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/calendar.png', // Use your calendar image here
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '2023',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Mood Trend Title
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Mood Trend',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Mood Trend Charts
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Pie Chart (60% of width)
                      Expanded(
                        flex: 60,
                        child: Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/graph.jpeg'), // Replace with pie chart
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      // Bar Chart (40% of width)
                      Expanded(
                        flex: 40,
                        child: Container(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildBar(0.9, Colors.green.shade400),
                              _buildBar(0.6, Colors.green.shade500),
                              _buildBar(0.4, Colors.green.shade600),
                              _buildBar(0.2, Colors.green.shade700),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pattern Notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                color: const Color(0xFF2A8240),
                child: const Text(
                  'Noticing patterns? Try adjusting your routine!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Journey Stats
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Journey Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A8240),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          // Timeframe dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A8240).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedTimeframe,
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2A8240)),
                              elevation: 16,
                              style: const TextStyle(color: Color(0xFF2A8240)),
                              underline: Container(height: 0),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTimeframe = newValue!;
                                });
                              },
                              items: _timeframes.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Journey stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Entries', '${_journeyEntries.length}', Icons.note_alt),
                          _buildStatItem('Happy Days', '3', Icons.sentiment_very_satisfied),
                          _buildStatItem('Activities', '12', Icons.local_activity),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Growth trend
                      const Text(
                        'Garden Growth Trend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.75,
                          backgroundColor: Colors.grey[200],
                          color: const Color(0xFF2E8B57),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Starting Point',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Text(
                            '75% Growth',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Journey Timeline List
              Container(
                height: 300, // Fixed height for timeline list
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _journeyEntries.length,
                  itemBuilder: (context, index) {
                    return _buildJourneyEntryCard(_journeyEntries[index], index);
                  },
                ),
              ),

              const SizedBox(height: 80), // Space for bottom nav bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E8B57),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: 'Mood Garden',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park),
            label: 'Nursery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Nurturing Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 4, // Highlight the Profile tab since Journey is part of profile
        onTap: (index) {
          // Handle navigation for each tab
          switch (index) {
            case 0:
            // Navigate to Home Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MoodGardenHomeScreen(),
                ),
              );
              break;
            case 1:
            // Navigate to Mood Garden page
              Navigator.pop(context); // First go back to profile
              break;
            case 2:
            // Navigate to Nursery page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NurseryPage(),
                ),
              );
              break;
            case 3:
            // Navigate to Nurturing Activities
              break;
            case 4:
            // Navigate to Profile page (already in profile section)
              Navigator.pop(context); // Go back to main profile
              break;
          }
        },
      ),
    );
  }

  // Helper method to build a bar for the chart
  Widget _buildBar(double height, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 25,
        height: 130 * height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2A8240).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2A8240),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A8240),
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyEntryCard(JourneyEntry entry, int index) {
    // Get mood icon
    IconData moodIcon;
    Color moodColor;

    switch (entry.mood) {
      case 'Happy':
        moodIcon = Icons.sentiment_very_satisfied;
        moodColor = Colors.green;
        break;
      case 'Sad':
        moodIcon = Icons.sentiment_dissatisfied;
        moodColor = Colors.blue;
        break;
      case 'Angry':
        moodIcon = Icons.sentiment_very_dissatisfied;
        moodColor = Colors.red;
        break;
      default:
        moodIcon = Icons.sentiment_neutral;
        moodColor = Colors.amber;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Column(
            children: [
              // Line above (don't show for first item)
              if (index > 0)
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.white.withOpacity(0.5),
                ),

              // Dot
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: moodColor,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  moodIcon,
                  size: 14,
                  color: Colors.white,
                ),
              ),

              // Line below (don't show for last item)
              if (index < _journeyEntries.length - 1)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Entry content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and mood
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM d, yyyy').format(entry.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: moodColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              moodIcon,
                              size: 16,
                              color: moodColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.mood,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: moodColor,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Plant progress
                  Row(
                    children: [
                      const Text(
                        'Plant Growth:',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: entry.plantProgress,
                            backgroundColor: Colors.grey[200],
                            color: const Color(0xFF2E8B57),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(entry.plantProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E8B57),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Activities
                  if (entry.activities.isNotEmpty) ...[
                    const Text(
                      'Activities:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: entry.activities.map((activity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A8240).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            activity,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2A8240),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Notes
                  if (entry.notes.isNotEmpty) ...[
                    const Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.notes,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JourneyEntry {
  final DateTime date;
  final String mood;
  final List<String> activities;
  final double plantProgress;
  final String notes;

  JourneyEntry({
    required this.date,
    required this.mood,
    required this.activities,
    required this.plantProgress,
    required this.notes,
  });
}