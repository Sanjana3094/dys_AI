import 'dart:async';
import 'package:flutter/material.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';


//Custom clipper for wave shape
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);

    // Create a wave pattern
    final waveCount = 3;
    final waveWidth = size.width / waveCount;

    for (int i = 0; i < waveCount; i++) {
      path.quadraticBezierTo(
        waveWidth * (i + 0.5), // control point
        i % 2 == 0 ? 0 : size.height, // peak or valley
        waveWidth * (i + 1), // end point
        size.height / 2,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BreathingExercisesPage extends StatefulWidget {
  const BreathingExercisesPage({Key? key}) : super(key: key);

  @override
  _BreathingExercisesPageState createState() => _BreathingExercisesPageState();
}

class _BreathingExercisesPageState extends State<BreathingExercisesPage> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _breathCircleController;
  late AnimationController _backgroundColorController;
  late AnimationController _leavesController;
  late Animation<double> _breathCircleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _leavesAnimation;

  // Exercise state
  bool _isExerciseRunning = false;
  int _currentExerciseIndex = 0;
  int _currentCycleCount = 0;
  int _totalCycles = 3;
  String _currentPhase = 'Ready';
  Timer? _phaseTimer;

  // Theme colors
  final Color _themeGreen = const Color(0xFF2A8240);
  final Color _themeLightGreen = const Color(0xFF2E8B57);

  // Available breathing exercises
  final List<Map<String, dynamic>> _breathingExercises = [
    {
      'name': 'Deep Breaths',
      'description': 'Simple deep breathing to calm the mind',
      'icon': Icons.air,
      'phases': [
        {'name': 'Breathe In', 'duration': 4, 'color': Colors.blue},
        {'name': 'Hold', 'duration': 2, 'color': Colors.green},
        {'name': 'Breathe Out', 'duration': 4, 'color': Colors.teal},
      ],
    },
    {
      'name': '4-7-8 Technique',
      'description': 'Reduces anxiety and aids sleep',
      'icon': Icons.airline_seat_flat,
      'phases': [
        {'name': 'Breathe In', 'duration': 4, 'color': Colors.indigo},
        {'name': 'Hold', 'duration': 7, 'color': Colors.green},
        {'name': 'Breathe Out', 'duration': 8, 'color': Colors.lightBlue},
      ],
    },
    {
      'name': 'Box Breathing',
      'description': 'Calms the nervous system',
      'icon': Icons.crop_square,
      'phases': [
        {'name': 'Breathe In', 'duration': 4, 'color': Colors.green},
        {'name': 'Hold', 'duration': 4, 'color': Colors.amber},
        {'name': 'Breathe Out', 'duration': 4, 'color': Colors.orange},
        {'name': 'Hold', 'duration': 4, 'color': Colors.green},
      ],
    },
    {
      'name': 'Alternate Nostril',
      'description': 'Balances both brain hemispheres',
      'icon': Icons.sync_alt,
      'phases': [
        {'name': 'Right In', 'duration': 4, 'color': Colors.deepOrange},
        {'name': 'Hold', 'duration': 2, 'color': Colors.green},
        {'name': 'Left Out', 'duration': 4, 'color': Colors.blue},
        {'name': 'Left In', 'duration': 4, 'color': Colors.purple},
        {'name': 'Hold', 'duration': 2, 'color': Colors.green},
        {'name': 'Right Out', 'duration': 4, 'color': Colors.indigo},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();

    // Set up circle animation controller
    _breathCircleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _breathCircleAnimation = Tween<double>(begin: 0.9, end: 1.4).animate(
      CurvedAnimation(parent: _breathCircleController, curve: Curves.easeInOut),
    );

    // Set up background color animation controller
    _backgroundColorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.blue[100],
      end: Colors.blue[300],
    ).animate(_backgroundColorController);

    // Set up leaves animation controller
    _leavesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _leavesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _leavesController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathCircleController.dispose();
    _backgroundColorController.dispose();
    _leavesController.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _setCurrentExercise(int index) {
    setState(() {
      _currentExerciseIndex = index;
      _currentCycleCount = 0;
      _currentPhase = 'Ready';
      _stopExercise();
    });
  }

  void _startExercise() {
    setState(() {
      _isExerciseRunning = true;
      _startNextPhase(0);
    });
  }

  void _stopExercise() {
    _phaseTimer?.cancel();
    setState(() {
      _breathCircleController.reset();
      _backgroundColorController.reset();
      _leavesController.reset();
      _isExerciseRunning = false;
      _currentPhase = 'Ready';
    });
  }

  void _startNextPhase(int phaseIndex) {
    final currentExercise = _breathingExercises[_currentExerciseIndex];
    final phases = currentExercise['phases'] as List;

    // Check if we completed a full cycle
    if (phaseIndex >= phases.length) {
      _currentCycleCount++;

      // Check if we completed all cycles
      if (_currentCycleCount >= _totalCycles) {
        // Exercise complete
        setState(() {
          _isExerciseRunning = false;
          _currentPhase = 'Complete';
        });
        return;
      }

      // Start next cycle
      phaseIndex = 0;
    }

    // Get current phase
    final phase = phases[phaseIndex];
    final phaseName = phase['name'] as String;
    final phaseDuration = phase['duration'] as int;
    final phaseColor = phase['color'] as Color;

    // Update UI
    setState(() {
      _currentPhase = phaseName;
    });

    // Configure animation based on phase
    if (phaseName.contains('In')) {
      // Breathe in - expand circle
      _breathCircleAnimation = Tween<double>(begin: 0.9, end: 1.4).animate(
        CurvedAnimation(parent: _breathCircleController, curve: Curves.easeInOut),
      );

      // Leaves animation for inhale
      _leavesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _leavesController, curve: Curves.easeInOut),
      );
    } else if (phaseName.contains('Out')) {
      // Breathe out - contract circle
      _breathCircleAnimation = Tween<double>(begin: 1.4, end: 0.9).animate(
        CurvedAnimation(parent: _breathCircleController, curve: Curves.easeInOut),
      );

      // Leaves animation for exhale
      _leavesAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _leavesController, curve: Curves.easeInOut),
      );
    } else {
      // Hold - keep circle size constant
      final isAfterInhale = phaseIndex > 0 && phases[phaseIndex - 1]['name'].toString().contains('In');
      _breathCircleAnimation = Tween<double>(
        begin: isAfterInhale ? 1.4 : 0.9,
        end: isAfterInhale ? 1.4 : 0.9,
      ).animate(
        CurvedAnimation(parent: _breathCircleController, curve: Curves.linear),
      );

      // Leaves animation for hold
      _leavesAnimation = Tween<double>(
        begin: isAfterInhale ? 1.0 : 0.0,
        end: isAfterInhale ? 1.0 : 0.0,
      ).animate(
        CurvedAnimation(parent: _leavesController, curve: Curves.linear),
      );
    }

    // Update color animation
    _backgroundColorAnimation = ColorTween(
      begin: phaseColor.withOpacity(0.2),
      end: phaseColor.withOpacity(0.3),
    ).animate(_backgroundColorController);

    // Start animations
    _breathCircleController.forward(from: 0.0);
    _backgroundColorController.forward(from: 0.0);
    _leavesController.forward(from: 0.0);

    // Set timer for next phase
    _phaseTimer?.cancel();
    _phaseTimer = Timer(Duration(seconds: phaseDuration), () {
      _startNextPhase(phaseIndex + 1);
    });
  }

  // Leaf widget
  Widget _buildLeaf(double angle, double distance, Color color) {
    return AnimatedBuilder(
      animation: _leavesAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset.fromDirection(
            angle,
            distance * _leavesAnimation.value,
          ),
          child: Transform.rotate(
            angle: angle + 0.5,
            child: ClipPath(
              clipper: LeafClipper(),
              child: Container(
                width: 20,
                height: 30,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }

  // Square widget for box breathing
  Widget _buildSquareCorner(double angle, double distance, Color color) {
    return AnimatedBuilder(
      animation: _leavesAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset.fromDirection(
            angle,
            distance * _leavesAnimation.value,
          ),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }

  // Wave widget for deep breathing
  Widget _buildWave(double angle, double distance, Color color) {
    return AnimatedBuilder(
      animation: _leavesAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset.fromDirection(
            angle,
            distance * _leavesAnimation.value,
          ),
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              width: 35,
              height: 10,
              color: color,
            ),
          ),
        );
      },
    );
  }

  // Orb widget for 4-7-8 technique
  Widget _buildOrb(double angle, double distance, Color color) {
    return AnimatedBuilder(
      animation: _leavesAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset.fromDirection(
            angle,
            distance * _leavesAnimation.value,
          ),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate sizes based on screen to avoid overflow
    final screenSize = MediaQuery.of(context).size;
    final safePadding = MediaQuery.of(context).padding;

    // Adjust available height calculation to prevent overflow
    final availableHeight = screenSize.height -
        safePadding.top -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        16; // Extra padding for safety

    final breathingAreaHeight = availableHeight * 0.5; // Reduced from 0.55
    final exerciseAreaHeight = availableHeight * 0.5; // Increased from 0.45

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeGreen,
        elevation: 0,
        title: const Text(
          'Breathing Exercises',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Animated breathing area with fixed height
            SizedBox(
              height: breathingAreaHeight,
              child: AnimatedBuilder(
                animation: Listenable.merge([_breathCircleController, _backgroundColorController]),
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    color: _isExerciseRunning
                        ? _backgroundColorAnimation.value
                        : _currentExerciseIndex == 0 ? Colors.blue[50]
                        : _currentExerciseIndex == 1 ? Colors.indigo[50]
                        : _currentExerciseIndex == 2 ? Colors.green[50]
                        : Colors.orange[50],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Phase name
                          Text(
                            _currentPhase,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _currentPhase == 'Complete' ? _themeGreen : Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 16), // Reduced from 20

                          // Breathing circle with fixed size and plant elements
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Different visualizations for each exercise type - all using leaves but with color variations
                              if (_isExerciseRunning || _currentPhase == 'Complete') ...[
                                if (_currentExerciseIndex == 0) ...[
                                  // Deep Breaths - Blue leaves
                                  _buildLeaf(0.3, 70, Colors.blue[300]!),
                                  _buildLeaf(1.0, 70, Colors.blue[400]!),
                                  _buildLeaf(1.7, 70, Colors.blue[500]!),
                                  _buildLeaf(2.4, 70, Colors.blue[600]!),
                                  _buildLeaf(3.1, 70, Colors.blue[500]!),
                                  _buildLeaf(3.8, 70, Colors.blue[400]!),
                                  _buildLeaf(4.5, 70, Colors.blue[300]!),
                                  _buildLeaf(5.2, 70, Colors.blue[400]!),
                                ] else if (_currentExerciseIndex == 1) ...[
                                  // 4-7-8 Technique - Indigo leaves
                                  _buildLeaf(0.3, 70, Colors.indigo[300]!),
                                  _buildLeaf(1.0, 70, Colors.indigo[400]!),
                                  _buildLeaf(1.7, 70, Colors.indigo[500]!),
                                  _buildLeaf(2.4, 70, Colors.indigo[600]!),
                                  _buildLeaf(3.1, 70, Colors.indigo[500]!),
                                  _buildLeaf(3.8, 70, Colors.indigo[400]!),
                                  _buildLeaf(4.5, 70, Colors.indigo[300]!),
                                  _buildLeaf(5.2, 70, Colors.indigo[400]!),
                                ] else if (_currentExerciseIndex == 2) ...[
                                  // Box Breathing - Mixed green and orange leaves
                                  _buildLeaf(0.3, 70, Colors.green[400]!),
                                  _buildLeaf(1.0, 70, Colors.green[500]!),
                                  _buildLeaf(1.7, 70, Colors.amber[400]!),
                                  _buildLeaf(2.4, 70, Colors.amber[500]!),
                                  _buildLeaf(3.1, 70, Colors.orange[400]!),
                                  _buildLeaf(3.8, 70, Colors.orange[500]!),
                                  _buildLeaf(4.5, 70, Colors.green[400]!),
                                  _buildLeaf(5.2, 70, Colors.green[500]!),
                                ] else ...[
                                  // Alternate Nostril - Green leaves (original)
                                  _buildLeaf(0.3, 70, Colors.green[400]!),
                                  _buildLeaf(1.0, 70, Colors.green[500]!),
                                  _buildLeaf(1.7, 70, Colors.green[600]!),
                                  _buildLeaf(2.4, 70, Colors.green[700]!),
                                  _buildLeaf(3.1, 70, Colors.green[500]!),
                                  _buildLeaf(3.8, 70, Colors.green[400]!),
                                  _buildLeaf(4.5, 70, Colors.green[300]!),
                                  _buildLeaf(5.2, 70, Colors.green[500]!),
                                ]
                              ],

                              // Main breathing circle with different colors based on technique
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPhase == 'Complete'
                                      ? _themeGreen.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.8),
                                  border: Border.all(
                                    width: 2,
                                    color: _currentPhase == 'Complete'
                                        ? _themeGreen
                                        : _currentExerciseIndex == 0 ? Colors.blue
                                        : _currentExerciseIndex == 1 ? Colors.indigo
                                        : _currentExerciseIndex == 2 ? Colors.green
                                        : Colors.deepOrange,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _currentPhase == 'Complete'
                                      ? Icon(
                                    Icons.check_circle_outline,
                                    color: _themeGreen,
                                    size: 50,
                                  )
                                      : _currentPhase == 'Ready'
                                      ? Icon(
                                    _currentExerciseIndex == 0 ? Icons.air
                                        : _currentExerciseIndex == 1 ? Icons.airline_seat_flat
                                        : _currentExerciseIndex == 2 ? Icons.crop_square
                                        : Icons.sync_alt,
                                    color: _currentExerciseIndex == 0 ? Colors.blue[400]
                                        : _currentExerciseIndex == 1 ? Colors.indigo[400]
                                        : _currentExerciseIndex == 2 ? Colors.green[400]
                                        : Colors.deepOrange[400],
                                    size: 40,
                                  )
                                      : Icon(
                                    _currentPhase.contains('In') ? Icons.arrow_upward :
                                    _currentPhase.contains('Out') ? Icons.arrow_downward : Icons.remove,
                                    color: _currentExerciseIndex == 0 ? Colors.blue[700]
                                        : _currentExerciseIndex == 1 ? Colors.indigo[700]
                                        : _currentExerciseIndex == 2 ? Colors.green[700]
                                        : Colors.deepOrange[700],
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16), // Reduced from 20

                          // Cycles counter or action buttons
                          if (_isExerciseRunning)
                            Column(
                              children: [
                                Text(
                                  'Cycle ${_currentCycleCount + 1} of $_totalCycles',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: _stopExercise,
                                  icon: const Icon(Icons.stop_circle_outlined),
                                  label: const Text('Stop'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          else if (_currentPhase == 'Complete')
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentPhase = 'Ready';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _themeGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text('Try Another'),
                            )
                          else
                            ElevatedButton(
                              onPressed: _startExercise,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _themeGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: const Text('Start'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Exercise selection area with fixed height
            Container(
              height: exerciseAreaHeight,
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                children: [
                  const Text(
                    'Choose a Breathing Exercise',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Exercise cards
                  for (int i = 0; i < _breathingExercises.length; i++)
                    _buildExerciseCard(i),

                  const SizedBox(height: 10),

                  // Simple benefits
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _themeGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.spa, color: Colors.green[700], size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Reduces stress • Improves focus • Better sleep',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _themeLightGreen,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
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
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MoodGardenHomeScreen()),
              );
              break;
            case 1:
              Navigator.pop(context);
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NurseryPage()),
              );
              break;
            case 3:
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildExerciseCard(int index) {
    final exercise = _breathingExercises[index];
    final isSelected = index == _currentExerciseIndex;

    return GestureDetector(
      onTap: () {
        if (!_isExerciseRunning) {
          _setCurrentExercise(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? _themeGreen.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _themeGreen : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Exercise icon with plant theme
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? _themeGreen : Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                exercise['icon'] as IconData,
                color: isSelected ? Colors.white : Colors.green[700],
                size: 18,
              ),
            ),

            const SizedBox(width: 10),

            // Exercise name and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? _themeGreen : Colors.black87,
                    ),
                  ),
                  Text(
                    exercise['description'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Icon(
                Icons.spa,
                color: _themeGreen,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for leaf shape
class LeafClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(0, size.height / 2, size.width / 2, size.height);
    path.quadraticBezierTo(size.width, size.height / 2, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}