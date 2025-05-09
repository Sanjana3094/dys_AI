import 'package:flutter/material.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'hydration_page.dart';
import 'breathing_exercises_page.dart';
import 'positivity_page.dart';
import 'mindful_moments_page.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

class NurturingActivitiesPage extends StatelessWidget {
  const NurturingActivitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // Lighter, more faded garden background
              image: DecorationImage(
                image: const AssetImage('assets/images/garden.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.2), // More opacity to fade the background
                  BlendMode.lighten,
                ),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Semi-transparent overlay to further lighten the background
                  Container(
                    color: Colors.white.withOpacity(0.4),
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        // Title
                        const Center(
                          child: Text(
                            'Nurturing Activities',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A8240),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF2A8240).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Take a moment to nurture your well-being with these activities',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2A8240),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Activity cards
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Row 1: Hydration and Breathing exercises
                                SizedBox(
                                  height: 320, // Fixed height for the row
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Hydration Card
                                      Expanded(
                                        flex: 1, // Equal flex factor
                                        child: _buildActivityCard(
                                          context,
                                          'Hydration Reminders',
                                          'Stay hydrated throughout the day.',
                                          'assets/images/hydration.jpg',
                                          const HydrationPage(),
                                          'Start',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Breathing Card
                                      Expanded(
                                        flex: 1, // Equal flex factor
                                        child: _buildActivityCard(
                                          context,
                                          'Guided Breathing',
                                          'Relax and refocus.',
                                          'assets/images/meditation.jpg',
                                          const BreathingExercisesPage(),
                                          'Begin',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Row 2: Mindful Moments and Positivity
                                SizedBox(
                                  height: 320, // Fixed height for the row
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Mindful Moments Card
                                      Expanded(
                                        flex: 1, // Equal flex factor
                                        child: _buildActivityCard(
                                          context,
                                          'Mindful Moments',
                                          'Be present and aware.',
                                          'assets/images/mindful.jpg',
                                          const MindfulMomentsPage(),
                                          'Focus',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Positivity Card
                                      Expanded(
                                        flex: 1, // Equal flex factor
                                        child: _buildActivityCard(
                                          context,
                                          'Daily Affirmation',
                                          'Start with positivity.',
                                          'assets/images/positivity.jpg',
                                          const PositivityPage(),
                                          'Read',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),

                        // Close button
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),

                        // Space for bottom navigation bar
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
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
        currentIndex: 3, // Nurturing Activities tab
        context: context,
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context,
      String title,
      String subtitle,
      String imagePath,
      Widget destinationPage,
      String buttonText,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF2A8240).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with fixed height
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 150, // Fixed height for all images
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Title and subtitle in a container with fixed height
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A8240),
                      fontFamily: 'Montserrat',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Montserrat',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(), // Pushes button to bottom
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => destinationPage),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A8240),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}