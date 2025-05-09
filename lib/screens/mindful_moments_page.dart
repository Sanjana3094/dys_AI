import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

// Custom painter for the growing plant
class PlantGrowthPainter extends CustomPainter {
  final double progress;
  final Color baseColor;

  PlantGrowthPainter({
    required this.progress,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final centerX = width / 2;

    // Paint for stem
    final stemPaint = Paint()
      ..color = baseColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Paint for leaves
    final leafPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    // Calculate how much of the plant to show based on progress
    final growthHeight = height * (1 - progress);

    // Draw the stem (grows from bottom to top)
    final stemPath = Path();
    stemPath.moveTo(centerX, height);

    // Wavy stem path
    for (double y = height; y >= growthHeight; y -= 5) {
      final waveOffset = sin((height - y) / 10) * 3;
      stemPath.lineTo(centerX + waveOffset, y);
    }

    canvas.drawPath(stemPath, stemPaint);

    // Draw leaves at different points along the stem (if progress allows)
    if (progress < 0.7) {
      // First leaf pair (right and left)
      _drawLeaf(canvas, centerX, height * 0.7, 0.3, 20, true, leafPaint);
      _drawLeaf(canvas, centerX, height * 0.7, 0.3, 20, false, leafPaint);
    }

    if (progress < 0.5) {
      // Second leaf pair
      _drawLeaf(canvas, centerX, height * 0.5, 0.4, 25, true, leafPaint);
      _drawLeaf(canvas, centerX, height * 0.5, 0.4, 25, false, leafPaint);
    }

    if (progress < 0.3) {
      // Third leaf pair (near top)
      _drawLeaf(canvas, centerX, height * 0.3, 0.3, 15, true, leafPaint);
      _drawLeaf(canvas, centerX, height * 0.3, 0.3, 15, false, leafPaint);
    }

    // Draw flower/bud at the top if almost complete
    if (progress < 0.2) {
      final flowerPaint = Paint()
        ..color = baseColor.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      // Draw simple flower/bud
      canvas.drawCircle(
        Offset(centerX, growthHeight),
        10,
        flowerPaint,
      );

      // Add small petals
      final petalRadius = 6.0;

      // Top petal
      canvas.drawCircle(
        Offset(centerX, growthHeight - petalRadius),
        petalRadius,
        flowerPaint,
      );

      // Right petal
      canvas.drawCircle(
        Offset(centerX + petalRadius, growthHeight),
        petalRadius,
        flowerPaint,
      );

      // Bottom petal
      canvas.drawCircle(
        Offset(centerX, growthHeight + petalRadius),
        petalRadius,
        flowerPaint,
      );

      // Left petal
      canvas.drawCircle(
        Offset(centerX - petalRadius, growthHeight),
        petalRadius,
        flowerPaint,
      );
    }
  }

  // Helper method to draw a leaf
  void _drawLeaf(
      Canvas canvas,
      double centerX,
      double y,
      double size,
      double angle,
      bool isRight,
      Paint paint
      ) {
    final leafPath = Path();
    final direction = isRight ? 1 : -1;

    // Starting point at the stem
    leafPath.moveTo(centerX, y);

    // Control points for the leaf curve
    final cp1x = centerX + direction * (size * 40);
    final cp1y = y - (size * 20);
    final cp2x = centerX + direction * (size * 20);
    final cp2y = y - (size * 40);

    // End point of the leaf
    final endX = centerX;
    final endY = y;

    // Draw the curve
    leafPath.quadraticBezierTo(cp1x, cp1y, endX + direction * (size * 30), endY - (size * 10));
    leafPath.quadraticBezierTo(cp2x, cp2y, endX, endY);

    // Rotate the leaf
    final angleRadians = angle * pi / 180 * direction;
    final translationMatrix = Matrix4.identity()
      ..translate(centerX, y)
      ..rotateZ(angleRadians)
      ..translate(-centerX, -y);

    leafPath.transform(translationMatrix.storage);

    canvas.drawPath(leafPath, paint);
  }

  @override
  bool shouldRepaint(PlantGrowthPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class MindfulMomentsPage extends StatefulWidget {
  const MindfulMomentsPage({Key? key}) : super(key: key);

  @override
  _MindfulMomentsPageState createState() => _MindfulMomentsPageState();
}

class _MindfulMomentsPageState extends State<MindfulMomentsPage> with TickerProviderStateMixin {
  // Timer properties
  int _selectedMinutes = 5;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  bool _isTimerComplete = false;
  Timer? _timer;

  // Background animation controller
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  // Focus quotes
  final List<String> _focusQuotes = [
    "Be present in this moment, here and now.",
    "Each breath is a new beginning.",
    "Let your thoughts come and go without judgment.",
    "Find peace in the stillness between your thoughts.",
    "Your mind is like a garden; tend to it with care.",
    "Notice the space between your thoughts expanding.",
    "Breathe in calm, breathe out tension.",
    "You are exactly where you need to be right now.",
    "This moment is your only responsibility.",
  ];
  int _currentQuoteIndex = 0;

  // Ambient sound selection
  String _selectedSound = 'Nature';
  final List<String> _availableSounds = [
    'Nature',
    'Rain',
    'Ocean',
    'Forest',
    'None'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize breathing animation controller
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _breathingController.repeat(reverse: true);

    // Initialize timer seconds
    _remainingSeconds = _selectedMinutes * 60;

    // Set random quote
    _currentQuoteIndex = DateTime.now().second % _focusQuotes.length;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _isTimerPaused = false;
      _isTimerComplete = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;

          // Change quote every 30 seconds
          if (_remainingSeconds % 30 == 0) {
            _currentQuoteIndex = (_currentQuoteIndex + 1) % _focusQuotes.length;
          }
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
          _isTimerComplete = true;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerPaused = true;
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _selectedMinutes * 60;
      _isTimerRunning = false;
      _isTimerPaused = false;
      _isTimerComplete = false;
      _currentQuoteIndex = DateTime.now().second % _focusQuotes.length;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E7D2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        elevation: 0,
        title: const Text(
          'Mindful Moments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
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
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTimerSection(),
                  _buildControlsSection(),
                  _buildSettingsSection(),

                  // Add extra space at the bottom for the navigation bar
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Add the floating chatbot button
          const FloatingChatbotButton(),
        ],
      ),
      // Replace with shared bottom navigation bar
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 3, // Nurturing Activities tab (which includes Mindful Moments)
        context: context,
      ),
    );
  }

  Widget _buildTimerSection() {
    // Calculate progress percentage for plant growth
    double progressPercentage = 1.0;
    if (!_isTimerComplete) {
      int totalSeconds = _selectedMinutes * 60;
      progressPercentage = (_remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated breathing background
        AnimatedBuilder(
          animation: _breathingController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2A8240),
                    const Color(0xFF2A8240).withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Timer display at the top
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A8240),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Plant visualization in the center
                  Center(
                    child: Container(
                      width: 200 * _breathingAnimation.value,
                      height: 200 * _breathingAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Container(
                          width: 170 * _breathingAnimation.value,
                          height: 170 * _breathingAnimation.value,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: _isTimerComplete
                                ? Image.asset(
                              'assets/images/plant1.webp', // Full grown plant when complete
                              fit: BoxFit.contain,
                              height: 120,
                              width: 120,
                            )
                                : CustomPaint(
                              painter: PlantGrowthPainter(
                                progress: progressPercentage,
                                baseColor: const Color(0xFF2A8240),
                              ),
                              size: const Size(120, 120),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Mindfulness quote overlay
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Text(
            _focusQuotes[_currentQuoteIndex],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontFamily: 'Montserrat',
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildControlsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Timer buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Start/Resume button
              if (!_isTimerRunning && (_isTimerPaused || !_isTimerComplete))
                _buildControlButton(
                  _isTimerPaused ? 'Resume' : 'Start',
                  Icons.play_arrow,
                  _startTimer,
                ),

              // Pause button
              if (_isTimerRunning)
                _buildControlButton(
                  'Pause',
                  Icons.pause,
                  _pauseTimer,
                ),

              // Reset button
              _buildControlButton(
                'Reset',
                Icons.refresh,
                _resetTimer,
              ),

              // Done button (shows when timer completes)
              if (_isTimerComplete)
                _buildControlButton(
                  'Done',
                  Icons.check,
                      () {
                    Navigator.pop(context);
                    // Show a completed message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mindful moment completed! Your garden is growing.'),
                        backgroundColor: Color(0xFF1A5E29),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Duration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A8240),
              fontFamily: 'Montserrat',
            ),
          ),

          const SizedBox(height: 16),

          // Duration selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDurationButton(1),
              _buildDurationButton(3),
              _buildDurationButton(5),
              _buildDurationButton(10),
              _buildDurationButton(15),
            ],
          ),

          const SizedBox(height: 30),

          // Ambient sounds
          const Text(
            'Ambient Sound',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A8240),
              fontFamily: 'Montserrat',
            ),
          ),

          const SizedBox(height: 16),

          // Sound selector
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableSounds.map((sound) {
              final isSelected = _selectedSound == sound;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSound = sound;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2A8240) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2A8240),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getSoundIcon(sound),
                        color: isSelected ? Colors.white : const Color(0xFF2A8240),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        sound,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF2A8240),
                          fontFamily: 'Montserrat',
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // Benefits of mindfulness
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Benefits of Mindfulness',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A8240),
                    fontFamily: 'Montserrat',
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  '• Reduces stress and anxiety\n'
                      '• Improves focus and concentration\n'
                      '• Enhances emotional regulation\n'
                      '• Promotes better sleep\n'
                      '• Supports overall mental well-being',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A8240),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _buildDurationButton(int minutes) {
    final isSelected = _selectedMinutes == minutes;

    return GestureDetector(
      onTap: () {
        if (!_isTimerRunning && !_isTimerPaused) {
          setState(() {
            _selectedMinutes = minutes;
            _remainingSeconds = minutes * 60;
          });
        }
      },
      child: Container(
        width: 55,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A8240) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2A8240),
            width: 1,
          ),
        ),
        child: Text(
          '$minutes min',
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2A8240),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Montserrat',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  IconData _getSoundIcon(String sound) {
    switch (sound) {
      case 'Nature':
        return Icons.forest;
      case 'Rain':
        return Icons.water_drop;
      case 'Ocean':
        return Icons.waves;
      case 'Forest':
        return Icons.park;
      case 'None':
        return Icons.volume_off;
      default:
        return Icons.music_note;
    }
  }
}