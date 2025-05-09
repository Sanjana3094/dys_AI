import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos;
import 'home_screen.dart'; // Import home screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
      ),
      home: const DysaiLoginScreen(),
    );
  }
}

class DysaiLoginScreen extends StatelessWidget {
  const DysaiLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 400,
          height: 600,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2D8), // Cream/beige background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Background floral elements
              ...buildFloralElements(),

              // Content
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D5233), // Dark green
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dysai',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D5233), // Dark green
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEE6C9), // Slightly darker cream for input
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: const Center(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEE6C9), // Slightly darker cream for input
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: const Center(
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to home screen on login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const DysaiHomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5233), // Dark green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildFloralElements() {
    return [
    // Top-left leaf stems
    CustomPaint(
      size: const Size(400, 600),
      painter: LeafStemPainter(
        stemColor: const Color(0xFF4D6B44),
        leafColor: const Color(0xFF4D6B44),
        positions: [
          const Offset(40, 30),
          const Offset(80, 120),
        ],
      ),
    ),

    // Top-right leaf stems
    CustomPaint(
    size: const Size(400, 600),
    painter: LeafStemPainter(
    stemColor: const Color(0xFF4D6B44),
    leafColor: const Color(0xFF4D6B44),
    positions: [
    const Offset(360, 60),
    const Offset(320, 150),
    ],
    isRightSide: true,
    ),
    ),

    // Bottom-left leaf stems
    CustomPaint(
    size: const Size(400, 600),
    painter: LeafStemPainter(
    stemColor: const Color(0xFF4D6B44),
    leafColor: const Color(0xFF4D6B44),
    positions: [
    const Offset(50, 480),
    const Offset(100, 540),
    ],
    ),
    ),

    // Bottom-right leaf stems
    CustomPaint(
    size: const Size(400, 600),
    painter: LeafStemPainter(
    stemColor: const Color(0xFF4D6B44),
    leafColor: const Color(0xFF4D6B44),
    positions: [
    const Offset(350, 450),
    const Offset(310, 520),
    ],
    isRightSide: true,
    ),
    ),

    // Yellow flowers - top left
    CustomPaint(
    size: const Size(400, 600),
    painter: FlowerPainter(
    flowerPositions: [
    const Offset(40, 30),
    const Offset(80, 120),
    ],
    flowerColors: [
    const Color(0xFFE9C46A), // Yellow gold
    const Color(0xFFE9C46A),
    ],
    flowerSizes: [30.0, 25.0],
    ),
    ),

    // Yellow flowers - top right
    CustomPaint(
    size: const Size(400, 600),
    painter: FlowerPainter(
    flowerPositions: [
    const Offset(360, 60),
    const Offset(320, 150),
    ],
    flowerColors: [
    const Color(0xFFE9C46A),
    const Color(0xFFE9C46A),
    ],
    flowerSizes: [22.0, 28.0],
    ),
    ),

    // Yellow flowers - bottom left
    CustomPaint(
    size: const Size(400, 600),
    painter: FlowerPainter(
    flowerPositions: [
    const Offset(50, 480),
    const Offset(100, 540),
    ],
    flowerColors: [
    const Color(0xFFE9C46A),
    const Color(0xFFE9C46A),
    ],
    flowerSizes: [25.0, 20.0],
    ),
    ),

    // Yellow flowers - bottom right
    CustomPaint(
    size: const Size(400, 600),
    painter: FlowerPainter(
    flowerPositions: [
    const Offset(350, 450),
    const Offset(310, 520),
    ],
    flowerColors: [
    const Color(0xFFE9C46A),
    const Color(0xFFE9C46A),
    ],
    flowerSizes: [28.0, 22.0],
    ),
    ),

    // Small decorative flowers
    CustomPaint(
    size: const Size(400, 600),
    painter: SmallFlowersPainter(
    positions: [
    const Offset(180, 70),
    const Offset(250, 100),
    const Offset(50, 330),
    const Offset(350, 350),
    const Offset(200, 500),
    ],
    colors: [
    const Color(0xFFE9C46A), // Yellow gold
      const Color(0xFFDEB754), // Lighter yellow
      const Color(0xFFE9C46A),
      const Color(0xFFDEB754),
      const Color(0xFFE9C46A),
    ],
      sizes: [18.0, 15.0, 16.0, 17.0, 14.0],
    ),
    ),
    ];
  }
}

class LeafStemPainter extends CustomPainter {
  final Color stemColor;
  final Color leafColor;
  final List<Offset> positions;
  final bool isRightSide;

  LeafStemPainter({
    required this.stemColor,
    required this.leafColor,
    required this.positions,
    this.isRightSide = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = stemColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final leafPaint = Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;

    for (final position in positions) {
      // Draw stem
      final stemPath = Path();
      stemPath.moveTo(position.dx, position.dy);

      if (isRightSide) {
        stemPath.quadraticBezierTo(
          position.dx - 20, position.dy + 70,
          position.dx - 10, position.dy + 100,
        );
      } else {
        stemPath.quadraticBezierTo(
          position.dx + 20, position.dy + 70,
          position.dx + 10, position.dy + 100,
        );
      }

      canvas.drawPath(stemPath, stemPaint);

      // Draw leaf
      final leafPath = Path();

      if (isRightSide) {
        leafPath.moveTo(position.dx, position.dy + 40);
        leafPath.quadraticBezierTo(
          position.dx - 30, position.dy + 50,
          position.dx - 10, position.dy + 70,
        );
        leafPath.quadraticBezierTo(
          position.dx - 5, position.dy + 60,
          position.dx, position.dy + 40,
        );
      } else {
        leafPath.moveTo(position.dx, position.dy + 40);
        leafPath.quadraticBezierTo(
          position.dx + 30, position.dy + 50,
          position.dx + 10, position.dy + 70,
        );
        leafPath.quadraticBezierTo(
          position.dx + 5, position.dy + 60,
          position.dx, position.dy + 40,
        );
      }

      canvas.drawPath(leafPath, leafPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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

      // Draw flower petals
      final petalPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      for (int j = 0; j < 8; j++) {
        final angle = j * pi / 4;

        final petalPath = Path();
        petalPath.moveTo(position.dx, position.dy);

        final controlPoint1 = Offset(
          position.dx + flowerSize * 0.7 * cos(angle - 0.4),
          position.dy + flowerSize * 0.7 * sin(angle - 0.4),
        );

        final endPoint = Offset(
          position.dx + flowerSize * cos(angle),
          position.dy + flowerSize * sin(angle),
        );

        final controlPoint2 = Offset(
          position.dx + flowerSize * 0.7 * cos(angle + 0.4),
          position.dy + flowerSize * 0.7 * sin(angle + 0.4),
        );

        petalPath.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          endPoint.dx, endPoint.dy,
          controlPoint2.dx, controlPoint2.dy,
        );

        petalPath.close();
        canvas.drawPath(petalPath, petalPaint);
      }

      // Draw flower center
      final centerPaint = Paint()
        ..color = const Color(0xFFE76F51)  // Orange-ish center
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, flowerSize * 0.3, centerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SmallFlowersPainter extends CustomPainter {
  final List<Offset> positions;
  final List<Color> colors;
  final List<double> sizes;

  SmallFlowersPainter({
    required this.positions,
    required this.colors,
    required this.sizes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < positions.length; i++) {
      final position = positions[i];
      final color = colors[i];
      final flowerSize = sizes[i];

      // Small simple flower with 5 petals
      final petalPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw 5 circles as petals
      for (int j = 0; j < 5; j++) {
        final angle = j * 2 * pi / 5;

        final petalCenter = Offset(
          position.dx + (flowerSize * 0.5) * cos(angle),
          position.dy + (flowerSize * 0.5) * sin(angle),
        );

        canvas.drawCircle(petalCenter, flowerSize * 0.4, petalPaint);
      }

      // Draw center
      final centerPaint = Paint()
        ..color = const Color(0xFF8B4513).withOpacity(0.7)  // Brown center
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, flowerSize * 0.25, centerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}