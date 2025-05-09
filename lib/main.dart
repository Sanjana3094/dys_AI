import 'package:flutter/material.dart';
import 'screens/sign_up.dart'; // Import the sign-up page
import 'screens/mood_garden_welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoodGarden',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xFF2E8B57), // Forest green for MoodGarden
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E8B57),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Changed the home to start with SignUpScreen
      home: const SignUpScreen(),
      // Define routes to preserve navigation to other screens
      routes: {
        '/mood_garden_welcome': (context) => const MoodGardenWelcomeScreen(),
      },
    );
  }
}