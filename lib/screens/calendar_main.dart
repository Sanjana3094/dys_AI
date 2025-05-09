import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos;

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
      home: const DysaiHomeScreen(),
    );
  }
}

class DysaiHomeScreen extends StatelessWidget {
  const DysaiHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 400,
          height: 700,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F2D8), // Cream/beige background
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              // Background floral elements
              ...buildFloralElements(),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    _buildHeader(),

                    const SizedBox(height: 15),
                    _buildDivider(), // New divider below the header
                    const SizedBox(height: 25),

                    // Calendar section
                    _buildCalendarSection(),

                    const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 20),

                    // Mood garden and Chat bot row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood garden section
                        Expanded(
                          child: _buildMoodGarden(),
                        ),

                        // Vertical divider between Mood Garden and Chat Bot
                        Container(
                          height: 80,
                          width: 1,
                          color: const Color(0xFFD0CAB0),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),

                        // Chat bot section
                        Expanded(
                          child: _buildChatBot(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 20),

                    // Connect with heating pad
                    _buildHeatingPadSection(),

                    const SizedBox(height: 60),

                    // About us section divider
                    _buildDivider(),
                    const SizedBox(height: 20),

                    // About us
                    _buildAboutUs(),

                    const SizedBox(height: 20),
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
        size: const Size(400, 700),
        painter: LeafStemPainter(
          stemColor: const Color(0xFF4D6B44),
          leafColor: const Color(0xFF4D6B44),
          positions: [
            const Offset(40, 70),
          ],
        ),
      ),

      // Top-right leaf stems
      CustomPaint(
        size: const Size(400, 700),
        painter: LeafStemPainter(
          stemColor: const Color(0xFF4D6B44),
          leafColor: const Color(0xFF4D6B44),
          positions: [
            const Offset(360, 70),
          ],
          isRightSide: true,
        ),
      ),

      // Chat bot leaf stem
      CustomPaint(
        size: const Size(400, 700),
        painter: LeafStemPainter(
          stemColor: const Color(0xFF4D6B44),
          leafColor: const Color(0xFF4D6B44),
          positions: [
            const Offset(360, 350),
          ],
          isRightSide: true,
        ),
      ),

      // Heating pad leaf stem
      CustomPaint(
        size: const Size(400, 700),
        painter: LeafStemPainter(
          stemColor: const Color(0xFF4D6B44),
          leafColor: const Color(0xFF4D6B44),
          positions: [
            const Offset(40, 490),
          ],
        ),
      ),

      // Yellow flowers - header
      CustomPaint(
        size: const Size(400, 700),
        painter: FlowerPainter(
          flowerPositions: [
            const Offset(40, 70),
            const Offset(360, 70),
          ],
          flowerColors: [
            const Color(0xFFE9C46A), // Yellow gold
            const Color(0xFFE9C46A),
          ],
          flowerSizes: [20.0, 20.0],
          moreDefinedPetals: true, // More defined petals
        ),
      ),

      // Chat bot flower
      CustomPaint(
        size: const Size(400, 700),
        painter: FlowerPainter(
          flowerPositions: [
            const Offset(360, 350),
          ],
          flowerColors: [
            const Color(0xFFE9C46A),
          ],
          flowerSizes: [18.0],
          moreDefinedPetals: true, // More defined petals
        ),
      ),

      // Heating pad flower
      CustomPaint(
        size: const Size(400, 700),
        painter: FlowerPainter(
          flowerPositions: [
            const Offset(40, 490),
          ],
          flowerColors: [
            const Color(0xFFE9C46A),
          ],
          flowerSizes: [18.0],
          moreDefinedPetals: true, // More defined petals
        ),
      ),
    ];
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFD0CAB0),
      width: double.infinity,
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          // Home icon
          Container(
            width: 45,
            height: 45,
            child: const Icon(
              Icons.home,
              color: Color(0xFF2D5233),
              size: 40,
            ),
          ),
          const SizedBox(height: 5),
          // Dysai text
          const Text(
            'Dysai',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D5233),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendar icon (replacing menstrual cup)
        Container(
          width: 40,
          height: 40,
          child: const Icon(
            Icons.calendar_today_rounded,
            color: Color(0xFF2D5233),
            size: 34,
          ),
        ),
        const SizedBox(width: 15),
        // Calendar text
        const Text(
          'Calendar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D5233),
          ),
        ),
        const Spacer(),
        // Calendar grid
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildMenstrualCupIcon() {
    return Container(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: MenstrualCupPainter(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Days header row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDayHeaderCell('S'),
            _buildDayHeaderCell('M'),
            _buildDayHeaderCell('T'),
            _buildDayHeaderCell('W'),
            _buildDayHeaderCell('T'),
            _buildDayHeaderCell('F'),
            _buildDayHeaderCell('S'),
          ],
        ),
        const SizedBox(height: 2),
        // Week 1
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDayCell('1'),
            _buildDayCell('2'),
            _buildDayCell('3'),
            _buildDayCell('4'),
            _buildDayCell('5'),
          ],
        ),
        const SizedBox(height: 2),
        // Week 2
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDayCell('6'),
            _buildDayCell('8'),
            _buildDayCell('9'),
            _buildDayCell('10'),
            _buildDayCell('11', isHighlighted: true), // Highlight 11 instead of 16
            _buildDayCell('12'),
          ],
        ),
        const SizedBox(height: 2),
        // Week 3
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDayCell('13'),
            _buildDayCell('15'),
            _buildDayCell('16'), // No longer highlighted
            _buildDayCell('17'),
            _buildDayCell('18'),
            _buildDayCell('19'),
          ],
        ),
        const SizedBox(height: 2),
        // Week 4
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDayCell('20'),
            _buildDayCell('22'),
            _buildDayCell('23'),
            _buildDayCell('24'),
            _buildDayCell('25'),
            _buildDayCell('26'),
          ],
        ),
      ],
    );
  }

  Widget _buildDayHeaderCell(String text) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D5233),
        ),
      ),
    );
  }

  Widget _buildDayCell(String text, {bool isHighlighted = false}) {
    return Container(
      width: 18,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      alignment: Alignment.center,
      decoration: isHighlighted ? BoxDecoration(
        color: const Color(0xFFE9C46A),
        shape: BoxShape.circle,
      ) : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF2D5233),
        ),
      ),
    );
  }

  Widget _buildMoodGarden() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flower pot (fixed, not in buildFloralElements) with different color flower
        Container(
          width: 42,
          height: 65,
          child: CustomPaint(
            painter: FlowerPotPainter(
              position: const Offset(21, 15),
              flowerColor: const Color(0xFFFF9B85), // Pink flower for Mood Garden
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Mood garden text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Mood',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5233),
              ),
            ),
            Text(
              'garden',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5233),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatBot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              'Chat bot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5233),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        _buildChatBubbleIcon(),
      ],
    );
  }

  Widget _buildChatBubbleIcon() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF2D5233),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.question_answer_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHeatingPadSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Heating pad icon
        _buildHeatingPadIcon(),
        const SizedBox(width: 15),
        // Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Connect with',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5233),
              ),
            ),
            Text(
              'heating pad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5233),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatingPadIcon() {
    return Container(
      width: 60,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFFFDDBD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD0AB7E),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.device_thermostat,
        color: Color(0xFFD0AB7E),
        size: 28,
      ),
    );
  }

  Widget _buildAboutUs() {
    return Center(
      child: const Text(
        'About us',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D5233),
        ),
      ),
    );
  }
}

// Flower Painter for 8-petal flowers with orange centers
class FlowerPainter extends CustomPainter {
  final List<Offset> flowerPositions;
  final List<Color> flowerColors;
  final List<double> flowerSizes;
  final bool moreDefinedPetals;

  FlowerPainter({
    required this.flowerPositions,
    required this.flowerColors,
    required this.flowerSizes,
    this.moreDefinedPetals = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < flowerPositions.length; i++) {
      final position = flowerPositions[i];
      final color = flowerColors[i];
      final flowerSize = flowerSizes[i];

      if (moreDefinedPetals) {
        // Enhanced petal definition approach

        // Draw distinct petals with sharper edges and clearer separation
        final petalPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        // More precise petals with better separation
        for (int j = 0; j < 8; j++) {
          final angle = j * pi / 4;

          // Draw each petal as a more distinct, separated shape
          final petalPath = Path();

          // Starting point closer to center but not at center
          final startPoint = Offset(
            position.dx + flowerSize * 0.2 * cos(angle),
            position.dy + flowerSize * 0.2 * sin(angle),
          );

          petalPath.moveTo(startPoint.dx, startPoint.dy);

          // Control points more spread out for defined petal shape
          final controlPoint1 = Offset(
            position.dx + flowerSize * 0.6 * cos(angle - 0.3),
            position.dy + flowerSize * 0.6 * sin(angle - 0.3),
          );

          // End point slightly further out for longer petals
          final endPoint = Offset(
            position.dx + flowerSize * 1.3 * cos(angle),
            position.dy + flowerSize * 1.3 * sin(angle),
          );

          final controlPoint2 = Offset(
            position.dx + flowerSize * 0.6 * cos(angle + 0.3),
            position.dy + flowerSize * 0.6 * sin(angle + 0.3),
          );

          // Draw the petal with more pronounced curve
          petalPath.cubicTo(
            controlPoint1.dx, controlPoint1.dy,
            endPoint.dx, endPoint.dy,
            controlPoint2.dx, controlPoint2.dy,
          );

          // Close the path back to starting point
          petalPath.close();

          // Fill the petal
          canvas.drawPath(petalPath, petalPaint);

          // Add petal outlines for better definition
          final outlinePaint = Paint()
            ..color = color.withOpacity(0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;

          canvas.drawPath(petalPath, outlinePaint);
        }

        // Draw flower center with gradient effect
        final centerPaint = Paint()
          ..color = const Color(0xFFE76F51)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(position, flowerSize * 0.4, centerPaint);

        // Inner center detail
        final innerCenterPaint = Paint()
          ..color = const Color(0xFFD35F41)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(position, flowerSize * 0.25, innerCenterPaint);

        // Add tiny highlight for 3D effect
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(position.dx - flowerSize * 0.07, position.dy - flowerSize * 0.07),
          flowerSize * 0.06,
          highlightPaint
        );
      } else {
        // Original flower drawing approach
        final petalPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        // First draw a background circle for the entire flower
        canvas.drawCircle(position, flowerSize * 0.8, petalPaint);

        // Then draw each petal on top to create more definition
        for (int j = 0; j < 8; j++) {
          final angle = j * pi / 4;

          final petalPath = Path();
          petalPath.moveTo(position.dx, position.dy);

          // More pronounced control points for better petal definition
          final controlPoint1 = Offset(
            position.dx + flowerSize * 0.8 * cos(angle - 0.5),
            position.dy + flowerSize * 0.8 * sin(angle - 0.5),
          );

          final endPoint = Offset(
            position.dx + flowerSize * 1.1 * cos(angle),
            position.dy + flowerSize * 1.1 * sin(angle),
          );

          final controlPoint2 = Offset(
            position.dx + flowerSize * 0.8 * cos(angle + 0.5),
            position.dy + flowerSize * 0.8 * sin(angle + 0.5),
          );

          petalPath.cubicTo(
            controlPoint1.dx, controlPoint1.dy,
            endPoint.dx, endPoint.dy,
            controlPoint2.dx, controlPoint2.dy,
          );

          petalPath.close();
          canvas.drawPath(petalPath, petalPaint);
        }

        // Draw outline around each petal for better definition
        final outlinePaint = Paint()
          ..color = color.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

        for (int j = 0; j < 8; j++) {
          final angle = j * pi / 4;

          final petalPath = Path();
          petalPath.moveTo(position.dx, position.dy);

          final controlPoint1 = Offset(
            position.dx + flowerSize * 0.8 * cos(angle - 0.5),
            position.dy + flowerSize * 0.8 * sin(angle - 0.5),
          );

          final endPoint = Offset(
            position.dx + flowerSize * 1.1 * cos(angle),
            position.dy + flowerSize * 1.1 * sin(angle),
          );

          final controlPoint2 = Offset(
            position.dx + flowerSize * 0.8 * cos(angle + 0.5),
            position.dy + flowerSize * 0.8 * sin(angle + 0.5),
          );

          petalPath.cubicTo(
            controlPoint1.dx, controlPoint1.dy,
            endPoint.dx, endPoint.dy,
            controlPoint2.dx, controlPoint2.dy,
          );

          petalPath.close();
          canvas.drawPath(petalPath, outlinePaint);
        }

        // Draw flower center
        final centerPaint = Paint()
          ..color = const Color(0xFFE76F51)  // Orange-ish center
          ..style = PaintingStyle.fill;

        canvas.drawCircle(position, flowerSize * 0.35, centerPaint);

        // Add center detail
        final centerDetailPaint = Paint()
          ..color = const Color(0xFFD35F41) // Darker orange for detail
          ..style = PaintingStyle.fill;

        canvas.drawCircle(position, flowerSize * 0.2, centerDetailPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Leaf Stem Painter
class LeafStemPainter extends CustomPainter {
  final Color stemColor;
  final Color leafColor;
  final List<Offset> positions;
  final bool isRightSide;
  final bool isSimpleStem;

  LeafStemPainter({
    required this.stemColor,
    required this.leafColor,
    required this.positions,
    this.isRightSide = false,
    this.isSimpleStem = false,
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
      if (isSimpleStem) {
        // Just draw a simple stem for About Us section
        final stemPath = Path();
        stemPath.moveTo(position.dx, position.dy);
        stemPath.lineTo(position.dx, position.dy - 40);
        canvas.drawPath(stemPath, stemPaint);
      } else {
        // Draw curved stem with leaf
        final stemPath = Path();
        stemPath.moveTo(position.dx, position.dy);

        if (isRightSide) {
          stemPath.quadraticBezierTo(
            position.dx - 10, position.dy + 40,
            position.dx - 5, position.dy + 70,
          );
        } else {
          stemPath.quadraticBezierTo(
            position.dx + 10, position.dy + 40,
            position.dx + 5, position.dy + 70,
          );
        }

        canvas.drawPath(stemPath, stemPaint);

        // Draw leaf
        final leafPath = Path();

        if (isRightSide) {
          leafPath.moveTo(position.dx, position.dy + 30);
          leafPath.quadraticBezierTo(
            position.dx - 20, position.dy + 40,
            position.dx - 5, position.dy + 50,
          );
          leafPath.quadraticBezierTo(
            position.dx - 2, position.dy + 40,
            position.dx, position.dy + 30,
          );
        } else {
          leafPath.moveTo(position.dx, position.dy + 30);
          leafPath.quadraticBezierTo(
            position.dx + 20, position.dy + 40,
            position.dx + 5, position.dy + 50,
          );
          leafPath.quadraticBezierTo(
            position.dx + 2, position.dy + 40,
            position.dx, position.dy + 30,
          );
        }

        canvas.drawPath(leafPath, leafPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Flower Pot Painter
class FlowerPotPainter extends CustomPainter {
  final Offset position;
  final Color flowerColor;

  FlowerPotPainter({
    required this.position,
    this.flowerColor = const Color(0xFFE9C46A), // Default is yellow gold
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw pot with better definition
    final potPaint = Paint()
      ..color = const Color(0xFFA76D60)
      ..style = PaintingStyle.fill;

    // Pot base
    final potPath = Path();
    potPath.moveTo(position.dx - 14, position.dy + 30);
    potPath.lineTo(position.dx - 14, position.dy + 50);
    potPath.lineTo(position.dx + 14, position.dy + 50);
    potPath.lineTo(position.dx + 14, position.dy + 30);
    potPath.close();

    canvas.drawPath(potPath, potPaint);

    // Add pot rim for better definition
    final potRimPaint = Paint()
      ..color = const Color(0xFF8A5A4D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final potRimPath = Path();
    potRimPath.moveTo(position.dx - 16, position.dy + 33);
    potRimPath.lineTo(position.dx + 16, position.dy + 33);

    canvas.drawPath(potRimPath, potRimPaint);

    // Draw stem
    final stemPaint = Paint()
      ..color = const Color(0xFF4D6B44)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final stemPath = Path();
    stemPath.moveTo(position.dx, position.dy + 30);
    stemPath.lineTo(position.dx, position.dy - 20);

    canvas.drawPath(stemPath, stemPaint);

    // Draw leaves with better definition
    // First leaf
    final leafPaint = Paint()
      ..color = const Color(0xFF4D6B44)
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    leafPath.moveTo(position.dx, position.dy);
    leafPath.quadraticBezierTo(
      position.dx + 22, position.dy + 2,
      position.dx + 8, position.dy + 15,
    );
    leafPath.quadraticBezierTo(
      position.dx + 2, position.dy + 8,
      position.dx, position.dy,
    );

    canvas.drawPath(leafPath, leafPaint);

    // Second leaf on other side for balance
    final leafPath2 = Path();
    leafPath2.moveTo(position.dx, position.dy + 10);
    leafPath2.quadraticBezierTo(
      position.dx - 18, position.dy + 12,
      position.dx - 7, position.dy + 20,
    );
    leafPath2.quadraticBezierTo(
      position.dx - 2, position.dy + 16,
      position.dx, position.dy + 10,
    );

    canvas.drawPath(leafPath2, leafPaint);

    // Draw flower with better definition (using modified FlowerPainter logic)
    final flowerSize = 15.0;
    final flowerPosition = Offset(position.dx, position.dy - 30);
    final petalPaint = Paint()
      ..color = flowerColor
      ..style = PaintingStyle.fill;

    // Base flower circle
    canvas.drawCircle(flowerPosition, flowerSize * 0.8, petalPaint);

    // Draw each petal
    for (int j = 0; j < 8; j++) {
      final angle = j * pi / 4;

      final petalPath = Path();
      petalPath.moveTo(flowerPosition.dx, flowerPosition.dy);

      final controlPoint1 = Offset(
        flowerPosition.dx + flowerSize * 0.8 * cos(angle - 0.5),
        flowerPosition.dy + flowerSize * 0.8 * sin(angle - 0.5),
      );

      final endPoint = Offset(
        flowerPosition.dx + flowerSize * 1.1 * cos(angle),
        flowerPosition.dy + flowerSize * 1.1 * sin(angle),
      );

      final controlPoint2 = Offset(
        flowerPosition.dx + flowerSize * 0.8 * cos(angle + 0.5),
        flowerPosition.dy + flowerSize * 0.8 * sin(angle + 0.5),
      );

      petalPath.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        endPoint.dx, endPoint.dy,
        controlPoint2.dx, controlPoint2.dy,
      );

      petalPath.close();
      canvas.drawPath(petalPath, petalPaint);
    }

    // Draw flower center - determine center color based on flower color
    final centerColor = (flowerColor == const Color(0xFFE9C46A))
        ? const Color(0xFFE76F51)  // Orange center for yellow flower
        : const Color(0xFFFF7057); // Brighter center for pink flower

    final centerPaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(flowerPosition, flowerSize * 0.35, centerPaint);

    // Add center detail - darken the center color
    final centerDetailColor = (flowerColor == const Color(0xFFE9C46A))
        ? const Color(0xFFD35F41) // Dark orange for yellow flower
        : const Color(0xFFE55B45); // Darker pink for pink flower

    final centerDetailPaint = Paint()
      ..color = centerDetailColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(flowerPosition, flowerSize * 0.2, centerDetailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Menstrual cup painter for the calendar icon
class MenstrualCupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D5233)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Cup shape
    path.moveTo(size.width * 0.3, size.height * 0.15);
    path.lineTo(size.width * 0.3, size.height * 0.65);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.9,
      size.width * 0.5, size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.9,
      size.width * 0.7, size.height * 0.65,
    );
    path.lineTo(size.width * 0.7, size.height * 0.15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}