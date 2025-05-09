import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'hydration_page.dart';
import 'mindful_moments_page.dart';
import 'breathing_exercises_page.dart';
import 'positivity_page.dart';
import 'nurturing_activities_page.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

class MoodGardenPage extends StatefulWidget {
  const MoodGardenPage({Key? key}) : super(key: key);

  @override
  _MoodGardenPageState createState() => _MoodGardenPageState();
}

class _MoodGardenPageState extends State<MoodGardenPage> {
  String _selectedMood = '';
  final Map<String, bool> _symptoms = {
    'Cramps': false,
    'Headache': false,
    'Back Pain': false,
    'Nausea': false,
    'Fatigue': false,
    'Other': false,
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF2A8240), // Forest green color
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mood Garden',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search wellness activities...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Montserrat',
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),

                  // Mood Selection Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How are you feeling today?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Mood Icons and Labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildMoodOption('Happy', Icons.sentiment_very_satisfied),
                            _buildMoodOption('Sad', Icons.sentiment_dissatisfied),
                            _buildMoodOption('Angry', Icons.sentiment_very_dissatisfied),
                            _buildMoodOption('Neutral', Icons.sentiment_neutral),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Symptoms Section
                        const Text(
                          'Please check any symptoms you have:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Symptoms Checkboxes
                        ..._symptoms.keys.map((symptom) => _buildCheckbox(symptom)),

                        const SizedBox(height: 24),

                        // Grow My Garden Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Save mood and symptoms data
                              _saveGardenData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2E8B57),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Grow my garden!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Garden Visualization
                        Center(
                          child: ClipOval(
                            child: Container(
                              width: size.width * 0.8,
                              height: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/garden1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Nurturing Activities Section
                        Container(
                          color: const Color(0xFF2A8240),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nurturing Activities',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Activity Grid
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const BreathingExercisesPage(),
                                          ),
                                        );
                                      },
                                      child: _buildActivityCard(
                                        'Breathing exercises',
                                        'assets/images/meditation.jpg',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const HydrationPage(),
                                          ),
                                        );
                                      },
                                      child: _buildActivityCard(
                                        'Hydration reminders',
                                        'assets/images/hydration.jpg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const MindfulMomentsPage(),
                                          ),
                                        );
                                      },
                                      child: _buildActivityCard(
                                        'Mindful moments',
                                        'assets/images/mindful.jpg',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const PositivityPage(),
                                          ),
                                        );
                                      },
                                      child: _buildActivityCard(
                                        'Positivity',
                                        'assets/images/positivity.jpg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80), // Space for bottom navigation
                ],
              ),
            ),
          ),

          // Add the floating chatbot button
          const FloatingChatbotButton(),
        ],
      ),
      // Replace with shared bottom navigation bar
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 1, // Mood Garden is at index 1
        context: context,
      ),
    );
  }

  Widget _buildMoodOption(String mood, IconData icon) {
    bool isSelected = _selectedMood == mood;

    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _selectedMood = mood;
            });
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            mood,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E8B57) : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String symptom) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _symptoms[symptom],
              onChanged: (value) {
                setState(() {
                  _symptoms[symptom] = value ?? false;
                });
              },
              fillColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => Colors.white,
              ),
              checkColor: const Color(0xFF2E8B57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            symptom,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  void _saveGardenData() {
    // Here you would save the mood and symptoms data
    // This is where you would implement the logic to update your garden
    // based on the user's selections

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your garden is growing! Your mood has been logged.'),
        backgroundColor: Color(0xFF1A5E29),
      ),
    );
  }
}