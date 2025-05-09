import 'package:flutter/material.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8240),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        elevation: 0,
        title: const Text(
          'Overview',
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Garden Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Garden Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A8240),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProgressItem('Plants', 65),
                        const SizedBox(height: 15),
                        _buildProgressItem('Relaxation', 40),
                        const SizedBox(height: 15),
                        _buildProgressItem('Daily Moods', 80),
                        const SizedBox(height: 30),

                        const Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A8240),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView(
                            children: const [
                              ActivityItem(
                                icon: Icons.spa,
                                title: 'New plant added: Lavender',
                                time: '2 hours ago',
                              ),
                              ActivityItem(
                                icon: Icons.self_improvement,
                                title: 'Completed: 10 min meditation',
                                time: 'Yesterday',
                              ),
                              ActivityItem(
                                icon: Icons.lightbulb,
                                title: 'Added mood entry: Happy',
                                time: 'Yesterday',
                              ),
                              ActivityItem(
                                icon: Icons.local_florist,
                                title: 'Garden streak: 7 days!',
                                time: '2 days ago',
                              ),
                            ],
                          ),
                        ),

                        // Add some bottom padding for the navigation bar
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                // Add space to accommodate bottom nav bar
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Add the floating chatbot button
          const FloatingChatbotButton(),
        ],
      ),
      // Add the shared bottom navigation bar with Mood Garden tab selected (index 1)
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 1, // Overview is part of Mood Garden section
        context: context,
      ),
    );
  }

  Widget _buildProgressItem(String title, int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A8240),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          color: const Color(0xFF2A8240),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;

  const ActivityItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A8240).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2A8240),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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