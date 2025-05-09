import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos;
import 'chatbot_page.dart'; // Import the chatbot page

void main() {
  runApp(const DysaiApp());
}

class DysaiApp extends StatelessWidget {
  const DysaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dysai Period Reminder',
      theme: ThemeData(
        primaryColor: const Color(0xFF234530),
        scaffoldBackgroundColor: const Color(0xFFF8EED0),
        fontFamily: 'Georgia',
      ),
      home: const PeriodReminderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PeriodReminderScreen extends StatelessWidget {
  const PeriodReminderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF234530);
    final Color backgroundColor = const Color(0xFFF8EED0);
    final Color creamColor = const Color(0xFFF5E9C0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Period Reminder',
          style: TextStyle(
            color: primaryGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Top left leaf decoration
          Positioned(
            left: 20,
            top: 80,
            child: CustomPaint(
              size: const Size(80, 120),
              painter: LeafStemPainter(
                color: primaryGreen.withOpacity(0.7),
                isRightFacing: false,
              ),
            ),
          ),

          // Top right leaf decoration
          Positioned(
            right: 20,
            top: 80,
            child: CustomPaint(
              size: const Size(80, 120),
              painter: LeafStemPainter(
                color: primaryGreen.withOpacity(0.7),
                isRightFacing: true,
              ),
            ),
          ),

          // Bottom flower and leaf decoration
          Positioned(
            right: 20,
            bottom: 40,
            child: CustomPaint(
              size: const Size(120, 180),
              painter: FlowerStemPainter(
                stemColor: primaryGreen.withOpacity(0.7),
                flowerColor: const Color(0xFFF5E9C0),
                centerColor: const Color(0xFFE6C27A),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 80,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'dysai',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Period Reminder',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your period is expected\nto start soon.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 22,
                          height: 1.4,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildDaysRemainingBanner(primaryGreen, creamColor),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // OK button
                          _buildOkButton(primaryGreen, context),

                          // Chat button
                          _buildChatButton(primaryGreen, context),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysRemainingBanner(Color primaryGreen, Color creamColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: creamColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                '3 days',
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                'remaining',
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 24,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          CustomPaint(
            size: const Size(40, 40),
            painter: FlowerPainter(
              petalColor: Colors.white.withOpacity(0.8),
              centerColor: const Color(0xFFE6C27A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOkButton(Color primaryGreen, BuildContext context) {
    return SizedBox(
      width: 120,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'OK',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
      ),
    );
  }

  Widget _buildChatButton(Color primaryGreen, BuildContext context) {
    return SizedBox(
      width: 120,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to chatbot page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: primaryGreen, width: 2),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
      ),
    );
  }
}

class LeafStemPainter extends CustomPainter {
  final Color color;
  final bool isRightFacing;

  LeafStemPainter({required this.color, required this.isRightFacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw stem
    final stemPath = Path();

    if (isRightFacing) {
      stemPath.moveTo(size.width * 0.7, 0);
      stemPath.lineTo(size.width * 0.8, size.height * 0.9);
      stemPath.lineTo(size.width * 0.9, size.height * 0.9);
      stemPath.lineTo(size.width * 0.8, 0);
      stemPath.close();
    } else {
      stemPath.moveTo(size.width * 0.3, 0);
      stemPath.lineTo(size.width * 0.2, size.height * 0.9);
      stemPath.lineTo(size.width * 0.1, size.height * 0.9);
      stemPath.lineTo(size.width * 0.2, 0);
      stemPath.close();
    }

    canvas.drawPath(stemPath, paint);

    // Draw leaves
    for (int i = 0; i < 3; i++) {
      final leafY = size.height * (0.2 + i * 0.3);
      final leafSize = size.width * 0.5;

      final leafPath = Path();
      if (isRightFacing) {
        leafPath.moveTo(size.width * 0.8, leafY);
        leafPath.quadraticBezierTo(
            size.width * 0.4, leafY - leafSize * 0.3,
            size.width * 0.2, leafY - leafSize * 0.1
        );
        leafPath.quadraticBezierTo(
            size.width * 0.4, leafY + leafSize * 0.3,
            size.width * 0.8, leafY
        );
      } else {
        leafPath.moveTo(size.width * 0.2, leafY);
        leafPath.quadraticBezierTo(
            size.width * 0.6, leafY - leafSize * 0.3,
            size.width * 0.8, leafY - leafSize * 0.1
        );
        leafPath.quadraticBezierTo(
            size.width * 0.6, leafY + leafSize * 0.3,
            size.width * 0.2, leafY
        );
      }
      leafPath.close();

      canvas.drawPath(leafPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FlowerPainter extends CustomPainter {
  final Color petalColor;
  final Color centerColor;

  FlowerPainter({required this.petalColor, required this.centerColor});

  @override
  void paint(Canvas canvas, Size size) {
    final petalPaint = Paint()
      ..color = petalColor
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill;

    // Draw petals
    for (int i = 0; i < 8; i++) {
      final angle = 2 * pi * i / 8;
      final x = size.width / 2 + size.width * 0.4 * cos(angle);
      final y = size.height / 2 + size.height * 0.4 * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        size.width * 0.25,
        petalPaint,
      );
    }

    // Draw center
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FlowerStemPainter extends CustomPainter {
  final Color stemColor;
  final Color flowerColor;
  final Color centerColor;

  FlowerStemPainter({
    required this.stemColor,
    required this.flowerColor,
    required this.centerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = stemColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Main stem
    final stemPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.9)
      ..quadraticBezierTo(
          size.width * 0.1, size.height * 0.7,
          size.width * 0.2, size.height * 0.2
      );

    canvas.drawPath(stemPath, stemPaint..style = PaintingStyle.stroke);

    // Draw leaves
    _drawLeaf(canvas, stemPaint, size.width * 0.25, size.height * 0.3, -20, size.width * 0.2);
    _drawLeaf(canvas, stemPaint, size.width * 0.35, size.height * 0.5, -30, size.width * 0.22);
    _drawLeaf(canvas, stemPaint, size.width * 0.42, size.height * 0.65, -40, size.width * 0.25);
    _drawLeaf(canvas, stemPaint, size.width * 0.47, size.height * 0.8, -50, size.width * 0.28);

    // Draw flower
    _drawFlower(
      canvas,
      Offset(size.width * 0.2, size.height * 0.1),
      size.width * 0.15,
      flowerColor,
      centerColor,
    );
  }

  void _drawLeaf(Canvas canvas, Paint paint, double x, double y, double angle, double size) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * pi / 180);

    final leafPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size * 0.5, -size * 0.3, size, -size * 0.1)
      ..quadraticBezierTo(size * 0.6, size * 0.3, 0, 0)
      ..close();

    canvas.drawPath(leafPath, paint..style = PaintingStyle.fill);
    canvas.restore();
  }

  void _drawFlower(Canvas canvas, Offset center, double radius, Color petalColor, Color centerColor) {
    final petalPaint = Paint()
      ..color = flowerColor
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill;

    // Draw petals
    for (int i = 0; i < 8; i++) {
      final angle = 2 * pi * i / 8;
      final x = center.dx + radius * 0.8 * cos(angle);
      final y = center.dy + radius * 0.8 * sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        radius * 0.6,
        petalPaint,
      );
    }

    // Draw center
    canvas.drawCircle(
      center,
      radius * 0.3,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}