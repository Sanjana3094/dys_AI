import 'package:flutter/material.dart';
import 'dart:math' as math;

class DysaiWelcomeScreen extends StatelessWidget {
  final VoidCallback onSignUpClicked;
  final VoidCallback onLoginClicked;

  const DysaiWelcomeScreen({
    Key? key,
    this.onSignUpClicked = _defaultCallback,
    this.onLoginClicked = _defaultCallback,
  }) : super(key: key);

  static void _defaultCallback() {}

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF5F2E9);
    final primaryGreen = const Color(0xFF3A5A40);

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: [
            // Top left leaf decoration
            Positioned(
              top: 20,
              left: 20,
              child: CustomPaint(
                size: const Size(100, 100),
                painter: LeafPainter(primaryGreen: primaryGreen, isLeft: true),
              ),
            ),

            // Top right leaf decoration
            Positioned(
              top: 20,
              right: 20,
              child: CustomPaint(
                size: const Size(100, 100),
                painter: LeafPainter(primaryGreen: primaryGreen, isLeft: false),
              ),
            ),

            // Bottom right flower and leaf decoration
            Positioned(
              bottom: 20,
              right: 20,
              child: CustomPaint(
                size: const Size(150, 150),
                painter: FlowerAndLeafPainter(primaryGreen: primaryGreen),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // App name
                  Text(
                    "dysai",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: primaryGreen,
                      fontFamily: 'Serif',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Welcome text
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: primaryGreen,
                      fontFamily: 'Serif',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    "Sign up or log in to continue.",
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 64),

                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onSignUpClicked,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Log in button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onLoginClicked,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeafPainter extends CustomPainter {
  final Color primaryGreen;
  final bool isLeft;

  LeafPainter({required this.primaryGreen, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint strokePaint = Paint()
      ..color = primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint fillPaint = Paint()
      ..color = primaryGreen.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // First leaf
    final path1 = Path();
    if (isLeft) {
      path1.moveTo(size.width * 0.2, 0);
      path1.quadraticBezierTo(size.width * 0.6, size.height * 0.2, size.width * 0.2, size.height * 0.4);
      path1.quadraticBezierTo(size.width * 0.1, size.height * 0.3, size.width * 0.2, 0);
    } else {
      path1.moveTo(size.width * 0.8, 0);
      path1.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.8, size.height * 0.4);
      path1.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width * 0.8, 0);
    }

    // Second leaf
    final path2 = Path();
    if (isLeft) {
      path2.moveTo(size.width * 0.4, size.height * 0.2);
      path2.quadraticBezierTo(size.width * 0.8, size.height * 0.5, size.width * 0.4, size.height * 0.8);
      path2.quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.4, size.height * 0.2);
    } else {
      path2.moveTo(size.width * 0.6, size.height * 0.2);
      path2.quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.6, size.height * 0.8);
      path2.quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width * 0.6, size.height * 0.2);
    }

    // Fill leaves
    canvas.drawPath(path1, fillPaint);
    canvas.drawPath(path2, fillPaint);

    // Draw strokes
    canvas.drawPath(path1, strokePaint);
    canvas.drawPath(path2, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FlowerAndLeafPainter extends CustomPainter {
  final Color primaryGreen;

  FlowerAndLeafPainter({required this.primaryGreen});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw flower
    final double centerX = size.width * 0.3;
    final double centerY = size.height * 0.3;
    final double petalRadius = size.width * 0.1;

    final Paint petalPaint = Paint()
      ..color = const Color(0xFFF5E8B7).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final Paint centerPaint = Paint()
      ..color = const Color(0xFFFFEB99)
      ..style = PaintingStyle.fill;

    // Draw petals
    for (int i = 0; i < 6; i++) {
      final double angle = i * (math.pi * 2 / 6);
      final double x = centerX + (petalRadius * 1.5 * math.cos(angle));
      final double y = centerY + (petalRadius * 1.5 * math.sin(angle));

      canvas.drawCircle(Offset(x, y), petalRadius, petalPaint);
    }

    // Draw center
    canvas.drawCircle(Offset(centerX, centerY), petalRadius * 0.7, centerPaint);

    // Draw leaf
    final Paint leafStrokePaint = Paint()
      ..color = primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint leafFillPaint = Paint()
      ..color = primaryGreen.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final Path leafPath = Path();
    leafPath.moveTo(size.width * 0.6, size.height * 0.4);
    leafPath.quadraticBezierTo(size.width * 0.2, size.height * 0.7, size.width * 0.6, size.height * 0.9);
    leafPath.quadraticBezierTo(size.width * 0.8, size.height * 0.7, size.width * 0.6, size.height * 0.4);

    canvas.drawPath(leafPath, leafFillPaint);
    canvas.drawPath(leafPath, leafStrokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Preview equivalent - This is how you would use it in a main.dart file
void main() {
  runApp(
    MaterialApp(
      home: DysaiWelcomeScreen(
        onSignUpClicked: () {
          print('Sign up clicked');
        },
        onLoginClicked: () {
          print('Login clicked');
        },
      ),
    ),
  );
}