import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DysaiChatbotApp());
}

class DysaiChatbotApp extends StatelessWidget {
  const DysaiChatbotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dysai Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xFFF8EED0),
      ),
      home: const ChatbotScreen(),
    );
  }
}

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF234530);

    return Scaffold(
      body: Stack(
        children: [
          // --- Gentle background flowers ---
          Positioned(
            top: 30,
            left: 20,
            child: CustomPaint(
              size: const Size(40, 40),
              painter: FlowerPainter(
                flowerPositions: [Offset(0, 0)],
                flowerColors: [const Color(0xFFE9C46A)],
                flowerSizes: [18.0],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: CustomPaint(
              size: const Size(40, 40),
              painter: FlowerPainter(
                flowerPositions: [Offset(0, 0)],
                flowerColors: [const Color(0xFFE9C46A)],
                flowerSizes: [18.0],
              ),
            ),
          ),

          // --- Main UI ---
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),

                const SizedBox(height: 20),
                _buildDivider(),

                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: const [
                        ChatBubble(
                          text: 'Hello! How can I assist you today?',
                          isUser: false,
                        ),
                        ChatBubble(
                          text: 'Tell me about period care tips.',
                          isUser: true,
                        ),
                        ChatBubble(
                          text: 'Sure! Here are some tips: Stay hydrated, maintain hygiene, and track your cycle regularly.',
                          isUser: false,
                        ),
                      ],
                    ),
                  ),
                ),

                _buildMessageInput(primaryGreen),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Center(
      child: Text(
        'Dysai',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D5233),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFD0CAB0),
      width: double.infinity,
    );
  }

  Widget _buildMessageInput(Color primaryGreen) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9C0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: primaryGreen),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ChatBubble widget
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color userBubbleColor = const Color(0xFF2D5233);
    final Color botBubbleColor = const Color(0xFFE9C46A);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? userBubbleColor : botBubbleColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// Simple Flower Painter
class FlowerPainter extends CustomPainter {
  final List<Offset> flowerPositions;
  final List<Color> flowerColors;
  final List<double> flowerSizes;

  FlowerPainter({
    required this.flowerPositions,
    required this.flowerColors,
    required this.flowerSizes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < flowerPositions.length; i++) {
      final position = flowerPositions[i];
      final color = flowerColors[i];
      final flowerSize = flowerSizes[i];

      final paint = Paint()..color = color;

      for (int j = 0; j < 5; j++) {
        double angle = (2 * pi / 5) * j;
        double x = position.dx + flowerSize * cos(angle);
        double y = position.dy + flowerSize * sin(angle);

        canvas.drawCircle(Offset(x, y), flowerSize / 3, paint);
      }

      // Center of the flower
      paint.color = color.withOpacity(0.8);
      canvas.drawCircle(position, flowerSize / 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}