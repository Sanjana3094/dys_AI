import 'package:flutter/material.dart';
import 'chatbot_page.dart'; // You'll need to create this page

class FloatingChatbotButton extends StatelessWidget {
  const FloatingChatbotButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30, // Position just above the bottom nav bar
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          // Navigate to chatbot page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
          );
        },
        backgroundColor: const Color(0xFFD42A82), // Corrected hexadecimal format
        child: const Icon(
          Icons.chat_rounded,
          color: Colors.white,
        ),
        mini: true, // Smaller size so it doesn't block too much content
      ),
    );
  }
}