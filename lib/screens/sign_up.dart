import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' show pi, sin, cos;
import 'login_page.dart'; // Import the login page

void main() {
  runApp(const MenstrualCycleApp());
}

class MenstrualCycleApp extends StatelessWidget {
  const MenstrualCycleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dysai Menstrual Cycle Tracker',
      theme: ThemeData(
        primaryColor: const Color(0xFF234530),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF234530),
          primary: const Color(0xFF234530),
          surface: const Color(0xFFF8EED0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5E9C0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        fontFamily: 'Georgia',
      ),
      home: const SignUpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _dobController = TextEditingController(); // Changed from age to date of birth
  final _emailController = TextEditingController();
  final _periodStartController = TextEditingController();
  final _cycleLengthController = TextEditingController();

  bool _isRegular = false;
  bool _hasPMS = false;

  // Colors matching the image
  final Color primaryGreen = const Color(0xFF234530);
  final Color backgroundBeige = const Color(0xFFF8EED0);
  final Color inputBeige = const Color(0xFFF5E9C0);
  final Color flowerYellow = const Color(0xFFE9C46A);
  final Color flowerOrange = const Color(0xFFE76F51);

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _periodStartController.dispose();
    _cycleLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBeige,
      body: Stack(
        children: [
          // Top flowers decoration only
          ...buildTopFlowers(),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),
                    // Header with flowers
                    _buildHeader(),
                    const SizedBox(height: 40),
                    // Form fields
                    _buildFormFields(),
                    const SizedBox(height: 30),
                    // Sign Up button
                    _buildSignUpButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: primaryGreen,
            fontFamily: 'Georgia',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Dysai',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
            fontFamily: 'Georgia',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormLabel('Name'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputBeige,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),

        _buildFormLabel('Date of Birth'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputBeige,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _dobController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
              hintText: 'Select your birth date',
            ),
            readOnly: true,
            onTap: () => _selectBirthDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your birth date';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),

        _buildFormLabel('Email'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputBeige,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel('Period Start Date'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: inputBeige,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _periodStartController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: InputBorder.none,
                        hintText: 'Select date',
                      ),
                      readOnly: true,
                      onTap: () => _selectPeriodDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildFormLabel('Cycle Length'),
                      _buildFormLabel(' (days)', isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: inputBeige,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _cycleLengthController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: InputBorder.none,
                        hintText: 'Enter days',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter length';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildFormLabel('Is your cycle regular?'),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: _isRegular,
              onChanged: (value) {
                setState(() {
                  _isRegular = value!;
                });
              },
              activeColor: primaryGreen,
            ),
            _buildFormLabel('Yes'),
            const SizedBox(width: 30),
            Radio<bool>(
              value: false,
              groupValue: _isRegular,
              onChanged: (value) {
                setState(() {
                  _isRegular = value!;
                });
              },
              activeColor: primaryGreen,
            ),
            _buildFormLabel('No'),
          ],
        ),
        const SizedBox(height: 20),

        _buildFormLabel('Do you experience PMS symptoms?'),
        const SizedBox(height: 8),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: _hasPMS,
              onChanged: (value) {
                setState(() {
                  _hasPMS = value!;
                });
              },
              activeColor: primaryGreen,
            ),
            _buildFormLabel('Yes'),
            const SizedBox(width: 30),
            Radio<bool>(
              value: false,
              groupValue: _hasPMS,
              onChanged: (value) {
                setState(() {
                  _hasPMS = value!;
                });
              },
              activeColor: primaryGreen,
            ),
            _buildFormLabel('No'),
          ],
        ),
      ],
    );
  }

  Widget _buildFormLabel(String text, {bool isSmall = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isSmall ? 14 : 16,
        fontWeight: FontWeight.bold,
        color: primaryGreen,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectPeriodDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _periodStartController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'name': _nameController.text,
        'dateOfBirth': _dobController.text,
        'email': _emailController.text,
        'periodStartDate': _periodStartController.text,
        'cycleLength': int.parse(_cycleLengthController.text),
        'isRegular': _isRegular,
        'hasPMS': _hasPMS,
      };

      print('Form submitted with data: $userData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign up successful!'),
          backgroundColor: primaryGreen,
        ),
      );

      // Navigate to login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DysaiLoginScreen()),
      );
    }
  }

  // Only include decorative elements at the top of the page
  List<Widget> buildTopFlowers() {
    final screenWidth = MediaQuery.of(context).size.width;

    return [
      // Left side flower with stem
      Positioned(
        top: 20,
        left: 10,
        child: CustomPaint(
          size: const Size(60, 100),
          painter: FlowerStemPainter(
            stemColor: primaryGreen,
            flowerColor: flowerYellow,
            centerColor: flowerOrange,
          ),
        ),
      ),

      // Right side flower with stem
      Positioned(
        top: 20,
        right: 10,
        child: CustomPaint(
          size: const Size(60, 100),
          painter: FlowerStemPainter(
            stemColor: primaryGreen,
            flowerColor: flowerYellow,
            centerColor: flowerOrange,
            isRightSide: true,
          ),
        ),
      ),

      // Small decorative flowers across top area
      Positioned(
        top: 50,
        left: screenWidth / 2 - 40,
        child: CustomPaint(
          size: const Size(25, 25),
          painter: SimpleFlowerPainter(
            petalColor: flowerYellow,
            centerColor: flowerOrange,
          ),
        ),
      ),

      Positioned(
        top: 70,
        right: screenWidth / 2 - 25,
        child: CustomPaint(
          size: const Size(20, 20),
          painter: SimpleFlowerPainter(
            petalColor: flowerYellow,
            centerColor: flowerOrange,
          ),
        ),
      ),

      // Top center flower
      Positioned(
        top: 30,
        left: screenWidth / 2 - 12.5,
        child: CustomPaint(
          size: const Size(25, 25),
          painter: SimpleFlowerPainter(
            petalColor: flowerYellow,
            centerColor: flowerOrange,
          ),
        ),
      ),
    ];
  }
}

// Flower Stem Painter
class FlowerStemPainter extends CustomPainter {
  final Color stemColor;
  final Color flowerColor;
  final Color centerColor;
  final bool isRightSide;

  FlowerStemPainter({
    required this.stemColor,
    required this.flowerColor,
    required this.centerColor,
    this.isRightSide = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stemPaint = Paint()
      ..color = stemColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final leafPaint = Paint()
      ..color = stemColor
      ..style = PaintingStyle.fill;

    // Draw the stem
    final stemPath = Path();
    if (isRightSide) {
      stemPath.moveTo(size.width * 0.3, 0);
      stemPath.quadraticBezierTo(
          size.width * 0.4, size.height * 0.5,
          size.width * 0.3, size.height
      );
    } else {
      stemPath.moveTo(size.width * 0.7, 0);
      stemPath.quadraticBezierTo(
          size.width * 0.6, size.height * 0.5,
          size.width * 0.7, size.height
      );
    }
    canvas.drawPath(stemPath, stemPaint);

    // Draw leaves
    final leaf1 = Path();
    final leaf2 = Path();

    if (isRightSide) {
      // First leaf
      leaf1.moveTo(size.width * 0.3, size.height * 0.3);
      leaf1.quadraticBezierTo(
          size.width * 0.1, size.height * 0.35,
          size.width * 0.3, size.height * 0.4
      );
      leaf1.close();

      // Second leaf
      leaf2.moveTo(size.width * 0.3, size.height * 0.6);
      leaf2.quadraticBezierTo(
          size.width * 0.1, size.height * 0.65,
          size.width * 0.3, size.height * 0.7
      );
      leaf2.close();
    } else {
      // First leaf
      leaf1.moveTo(size.width * 0.7, size.height * 0.3);
      leaf1.quadraticBezierTo(
          size.width * 0.9, size.height * 0.35,
          size.width * 0.7, size.height * 0.4
      );
      leaf1.close();

      // Second leaf
      leaf2.moveTo(size.width * 0.7, size.height * 0.6);
      leaf2.quadraticBezierTo(
          size.width * 0.9, size.height * 0.65,
          size.width * 0.7, size.height * 0.7
      );
      leaf2.close();
    }

    canvas.drawPath(leaf1, leafPaint);
    canvas.drawPath(leaf2, leafPaint);

    // Draw the flower
    final flowerCenter = isRightSide
        ? Offset(size.width * 0.3, 0)
        : Offset(size.width * 0.7, 0);

    drawFlower(canvas, flowerCenter, size.width * 0.2, flowerColor, centerColor);
  }

  void drawFlower(Canvas canvas, Offset center, double radius, Color petalColor, Color centerColor) {
    final petalPaint = Paint()
      ..color = petalColor
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill;

    // Draw petals
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final petalCenter = Offset(
          center.dx + radius * 0.7 * cos(angle),
          center.dy + radius * 0.7 * sin(angle)
      );

      canvas.drawCircle(petalCenter, radius * 0.5, petalPaint);
    }

    // Draw center
    canvas.drawCircle(center, radius * 0.4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Simple Flower Painter
class SimpleFlowerPainter extends CustomPainter {
  final Color petalColor;
  final Color centerColor;

  SimpleFlowerPainter({
    required this.petalColor,
    required this.centerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final petalPaint = Paint()
      ..color = petalColor
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = centerColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw petals
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final petalCenter = Offset(
          center.dx + radius * 0.6 * cos(angle),
          center.dy + radius * 0.6 * sin(angle)
      );

      canvas.drawCircle(petalCenter, radius * 0.4, petalPaint);
    }

    // Draw center
    canvas.drawCircle(center, radius * 0.3, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}