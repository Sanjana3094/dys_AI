import 'package:flutter/material.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

class HydrationPage extends StatefulWidget {
  const HydrationPage({Key? key}) : super(key: key);

  @override
  _HydrationPageState createState() => _HydrationPageState();
}

class _HydrationPageState extends State<HydrationPage> {
  // Track current question index
  int _currentQuestionIndex = 0;

  // Store user answers
  int _waterGlassesPerDay = 0;
  String _selectedReminderFrequency = '';
  List<String> _selectedBeverages = [];
  bool _isSubmitting = false;

  // Questions and options
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How many glasses of water do you drink in a day?',
      'type': 'slider',
      'min': 0,
      'max': 10,
    },
    {
      'question': 'How often would you like to receive hydration reminders?',
      'type': 'choice',
      'options': [
        'Every hour',
        'Every 2 hours',
        'Every 3 hours',
        'Morning, Afternoon, Evening',
        'Only when I need it'
      ],
    },
    {
      'question': 'Which beverages do you usually drink? (Select all that apply)',
      'type': 'multiple',
      'options': [
        'Water',
        'Tea',
        'Coffee',
        'Juices',
        'Sodas',
        'Energy drinks',
        'Smoothies'
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E7D2), // Light green background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        elevation: 0,
        title: const Text(
          'Hydration Tracker',
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
        child: _isSubmitting ? _buildCompletionScreen() : _buildQuestionScreen(),
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
        currentIndex: 3, // Highlight the Nurturing Activities tab
        onTap: (index) {
          // Handle navigation for each tab
          switch (index) {
            case 0:
            // Navigate to Home Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MoodGardenHomeScreen()),
              );
              break;
            case 1:
            // Navigate to Mood Garden page
              Navigator.pop(context); // Go back to previous page
              break;
            case 2:
            // Navigate to Nursery page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NurseryPage()),
              );
              break;
            case 3:
            // Already on Nurturing Activities
              break;
            case 4:
            // Navigate to Profile page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildQuestionScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.white.withOpacity(0.5),
              color: const Color(0xFF2E8B57),
              minHeight: 10,
            ),
          ),

          const SizedBox(height: 8),

          // Question counter
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            style: TextStyle(
              color: Colors.grey[800],
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Hydration icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A8240).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getQuestionIcon(),
                color: const Color(0xFF2A8240),
                size: 60,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Question text
          Text(
            _questions[_currentQuestionIndex]['question'],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A8240),
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Question content based on type
          Expanded(
            child: _buildQuestionContent(),
          ),

          // Navigation buttons
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button (don't show on first question)
                if (_currentQuestionIndex > 0)
                  ElevatedButton.icon(
                    onPressed: _previousQuestion,
                    icon: const Icon(Icons.arrow_back_ios),
                    label: const Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2A8240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  )
                else
                  const SizedBox(width: 100), // Empty space for alignment

                // Next/Submit button
                ElevatedButton.icon(
                  onPressed: () {
                    if (_canProceed()) {
                      if (_currentQuestionIndex < _questions.length - 1) {
                        _nextQuestion();
                      } else {
                        setState(() {
                          _isSubmitting = true;
                        });
                      }
                    } else {
                      // Show a snackbar if user hasn't answered
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please answer the question to continue'),
                          backgroundColor: Color(0xFF1A5E29),
                        ),
                      );
                    }
                  },
                  icon: Icon(_currentQuestionIndex < _questions.length - 1
                      ? Icons.arrow_forward_ios
                      : Icons.check),
                  label: Text(_currentQuestionIndex < _questions.length - 1
                      ? 'Next'
                      : 'Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A8240),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    final questionType = _questions[_currentQuestionIndex]['type'];

    if (questionType == 'slider') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display current value
          Text(
            _waterGlassesPerDay.toString(),
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A8240),
              fontFamily: 'Montserrat',
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'glasses',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontFamily: 'Montserrat',
            ),
          ),

          const SizedBox(height: 30),

          // Slider for water glasses
          Slider(
            value: _waterGlassesPerDay.toDouble(),
            min: _questions[_currentQuestionIndex]['min'].toDouble(),
            max: _questions[_currentQuestionIndex]['max'].toDouble(),
            divisions: _questions[_currentQuestionIndex]['max'],
            label: _waterGlassesPerDay.toString(),
            activeColor: const Color(0xFF2A8240),
            inactiveColor: const Color(0xFF2A8240).withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _waterGlassesPerDay = value.round();
              });
            },
          ),

          // Glasses icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.water_drop,
                  color: index < _waterGlassesPerDay ?
                  const Color(0xFF2A8240) :
                  Colors.grey.withOpacity(0.3),
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (questionType == 'choice') {
      return ListView.builder(
        itemCount: _questions[_currentQuestionIndex]['options'].length,
        itemBuilder: (context, index) {
          final option = _questions[_currentQuestionIndex]['options'][index];
          final isSelected = _selectedReminderFrequency == option;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedReminderFrequency = option;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2A8240) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2A8240) : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.white : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.white : const Color(0xFF2A8240),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Color(0xFF2A8240),
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (questionType == 'multiple') {
      return ListView.builder(
        itemCount: _questions[_currentQuestionIndex]['options'].length,
        itemBuilder: (context, index) {
          final option = _questions[_currentQuestionIndex]['options'][index];
          final isSelected = _selectedBeverages.contains(option);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedBeverages.remove(option);
                  } else {
                    _selectedBeverages.add(option);
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2A8240).withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2A8240) : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2A8240) : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF2A8240),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Montserrat',
                      ),
                    ),

                    if (option == 'Water' && isSelected)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(); // Fallback
  }

  Widget _buildCompletionScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Success Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2A8240).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF2A8240),
                size: 80,
              ),
            ),

            const SizedBox(height: 30),

            // Congratulation text
            const Text(
              'Hydration Plan Set!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A8240),
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'We\'ll remind you to stay hydrated throughout the day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Hydration Plan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A8240),
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Daily water glasses
                  _buildSummaryItem(
                    Icons.water_drop,
                    '$_waterGlassesPerDay glasses per day',
                  ),

                  const SizedBox(height: 15),

                  // Reminder frequency
                  _buildSummaryItem(
                    Icons.notifications,
                    'Reminders: $_selectedReminderFrequency',
                  ),

                  const SizedBox(height: 15),

                  // Preferred beverages
                  _buildSummaryItem(
                    Icons.local_drink,
                    'Preferred beverages:',
                    additionalContent: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedBeverages.map((beverage) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A8240).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            beverage,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2A8240),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Hydration tips
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A8240).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hydration Tips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A8240),
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    '• Start your day with a glass of water\n'
                        '• Keep a water bottle with you\n'
                        '• Set reminders to drink water\n'
                        '• Track your intake\n'
                        '• Infuse water with fruits for flavor',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Button to continue
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A8240),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String text, {Widget? additionalContent}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A8240).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2A8240),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontFamily: 'Montserrat',
                ),
              ),
              if (additionalContent != null) ...[
                const SizedBox(height: 10),
                additionalContent,
              ],
            ],
          ),
        ),
      ],
    );
  }

  IconData _getQuestionIcon() {
    switch (_currentQuestionIndex) {
      case 0:
        return Icons.water_drop;
      case 1:
        return Icons.notifications;
      case 2:
        return Icons.local_drink;
      default:
        return Icons.water_drop;
    }
  }

  bool _canProceed() {
    switch (_currentQuestionIndex) {
      case 0:
        return true; // Slider has a default value
      case 1:
        return _selectedReminderFrequency.isNotEmpty;
      case 2:
        return _selectedBeverages.isNotEmpty;
      default:
        return true;
    }
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }
}