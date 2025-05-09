import 'package:flutter/material.dart';
import 'mood_garden_home_screen.dart';
import 'mood_garden_page.dart';
import 'my_garden_page.dart'; // Import the new garden page
import 'nursery_page.dart';
import 'nurturing_activities_page.dart';
import 'profile_page.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex;
  final BuildContext context;

  const SharedBottomNav({
    Key? key,
    required this.currentIndex,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2E8B57),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(index, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.yard),
          label: 'Garden',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.park),
          label: 'Nursery',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement),
          label: 'Activities',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) {
      return; // Already on this page
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MoodGardenHomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GardenScreen()),

        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NurseryPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NurturingActivitiesPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }
}