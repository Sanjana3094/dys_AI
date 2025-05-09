import 'package:flutter/material.dart';
import 'mood_garden_home_screen.dart';
import 'profile_page.dart';
import 'nursery_page.dart';
import 'dart:math';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';

class PositivityPage extends StatefulWidget {
  const PositivityPage({Key? key}) : super(key: key);

  @override
  _PositivityPageState createState() => _PositivityPageState();
}

class _PositivityPageState extends State<PositivityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentCardIndex = 0;
  final Random _random = Random();
  bool _showingAffirmation = false;
  String _currentAffirmation = '';

  // Simplified affirmations list
  final Map<String, List<String>> _affirmations = {
    'Self-Care': [
      'Taking time for yourself is not selfish, it\'s necessary.',
      'You deserve moments of peace and rest.',
      'Your body is working hard for you, treat it with kindness.',
      'Listen to your body\'s needs today.',
    ],
    'Strength': [
      'You are stronger than you think.',
      'This discomfort is temporary, but your strength is enduring.',
      'You\'ve overcome difficult days before, and you will again.',
      'Each breath connects you to your inner strength.',
    ],
    'Comfort': [
      'It\'s okay to take it easy today.',
      'You are allowed to rest without guilt.',
      'Be gentle with yourself through this time.',
      'Your comfort matters.',
    ],
  };

  // Simplified wisdom cards
  final List<Map<String, dynamic>> _wisdomCards = [
    {
      'title': 'Honor Your Cycle',
      'content': 'Your menstrual cycle is a vital sign of health. Each phase brings different energies and needs.',
      'image': 'assets/images/period.jpg',
      'hasBeenLiked': false,
    },
    {
      'title': 'Connect With Nature',
      'content': 'Like the changing seasons, your body follows natural rhythms. Spending time in nature can remind you of these cycles.',
      'image': 'assets/images/plant1.webp',
      'hasBeenLiked': false,
    },
    {
      'title': 'Body Wisdom',
      'content': 'Your body communicates with you through sensations, energy levels, and emotions. Listen with compassion.',
      'image': 'assets/images/good.jpg',
      'hasBeenLiked': false,
    },
  ];

  // Tracking
  int _affirmationsViewed = 0;
  DateTime? _lastAffirmationTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Changed to 2 tabs
    _tabController.addListener(() {
      setState(() {}); // Rebuild on tab change
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showRandomAffirmation() {
    final currentTab = _tabController.index;
    String category;

    // Adjust logic for only two tabs
    switch (currentTab) {
      case 0:
        category = 'Self-Care';
        break;
      case 1:
        category = 'Strength';
        break;
      default:
        category = 'Self-Care';
    }

    final affirmations = _affirmations[category]!;
    final randomIndex = _random.nextInt(affirmations.length);

    setState(() {
      _showingAffirmation = true;
      _currentAffirmation = affirmations[randomIndex];
      _affirmationsViewed++;
      _lastAffirmationTime = DateTime.now();
    });

    // Hide affirmation after a few seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showingAffirmation = false;
        });
      }
    });
  }

  void _nextWisdomCard() {
    setState(() {
      _currentCardIndex = (_currentCardIndex + 1) % _wisdomCards.length;
    });
  }

  void _previousWisdomCard() {
    setState(() {
      _currentCardIndex = (_currentCardIndex - 1 + _wisdomCards.length) % _wisdomCards.length;
    });
  }

  void _toggleCardLike() {
    setState(() {
      _wisdomCards[_currentCardIndex]['hasBeenLiked'] = !_wisdomCards[_currentCardIndex]['hasBeenLiked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        elevation: 0,
        title: const Text(
          'Daily Positivity',
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Affirmations'),
            Tab(text: 'Wisdom'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildAffirmationsTab(),
              _buildWisdomTab(),
            ],
          ),
          // Floating affirmation display
          if (_showingAffirmation)
            Center(
              child: Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Color(0xFF2A8240),
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentAffirmation,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showingAffirmation = false;
                        });
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Color(0xFF2A8240),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Add the floating chatbot button
          const FloatingChatbotButton(),
        ],
      ),
      // Replace the existing bottom navigation bar with the shared one
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 3, // Nurturing Activities tab (which includes Positivity)
        context: context,
      ),
    );
  }

  Widget _buildAffirmationsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple icon and label
            const Icon(
              Icons.spa,
              color: Color(0xFF2A8240),
              size: 40,
            ),
            const SizedBox(height: 16),
            const Text(
              'Daily Affirmations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A8240),
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 20),

            // Affirmation counter
            if (_affirmationsViewed > 0)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A8240).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'You\'ve viewed $_affirmationsViewed affirmation${_affirmationsViewed == 1 ? '' : 's'} today',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Large affirmation button with animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: _showingAffirmation ? 0.9 : 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: ElevatedButton(
                    onPressed: _showingAffirmation ? null : _showRandomAffirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A8240),
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(30),
                      elevation: 2,
                      disabledBackgroundColor: const Color(0xFF2A8240).withOpacity(0.7),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 48,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Button label
            Text(
              _showingAffirmation ? 'Absorbing wisdom...' : 'Tap for an affirmation',
              style: TextStyle(
                fontSize: 16,
                color: _showingAffirmation ? Colors.grey : const Color(0xFF2A8240),
                fontFamily: 'Montserrat',
              ),
            ),

            const SizedBox(height: 40),

            // Category selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryPill('Self-Care', 0),
                const SizedBox(width: 16),
                _buildCategoryPill('Strength', 1),
              ],
            ),

            const SizedBox(height: 30),

            // Last affirmation time display
            if (_lastAffirmationTime != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Last affirmation: ${_formatTime(_lastAffirmationTime!)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Affirmation journal prompt
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF2A8240).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Journal Prompt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A8240),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'What\'s one small way you can show yourself kindness today?',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.8),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write your thoughts here...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF2A8240),
                        ),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Save journal entry functionality would go here
                      },
                      child: const Text(
                        'Save to Journal',
                        style: TextStyle(
                          color: Color(0xFF2A8240),
                          fontWeight: FontWeight.bold,
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
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Widget _buildWisdomTab() {
    final currentCard = _wisdomCards[_currentCardIndex];
    final bool isLiked = currentCard['hasBeenLiked'];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: Color(0xFF2A8240),
            size: 40,
          ),
          const SizedBox(height: 16),
          const Text(
            'Wellness Wisdom',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A8240),
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 30),

          // Simplified wisdom card with interactive elements
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF2A8240).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card image
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            currentCard['image'],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Save button overlay
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: _toggleCardLike,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Card counter
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentCardIndex + 1}/${_wisdomCards.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Card content
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentCard['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A8240),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentCard['content'],
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.8),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const Spacer(),

                          // Interactive action row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Navigation controls
                              Row(
                                children: [
                                  InkWell(
                                    onTap: _previousWisdomCard,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A8240).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 16,
                                        color: Color(0xFF2A8240),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: _nextWisdomCard,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A8240).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Color(0xFF2A8240),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Share button
                              TextButton.icon(
                                onPressed: () {
                                  // Share functionality
                                },
                                icon: const Icon(
                                  Icons.share,
                                  size: 16,
                                  color: Color(0xFF2A8240),
                                ),
                                label: const Text(
                                  'Share',
                                  style: TextStyle(
                                    color: Color(0xFF2A8240),
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress indicators
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _wisdomCards.length,
                  (index) => Container(
                width: _currentCardIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _currentCardIndex == index
                      ? const Color(0xFF2A8240)
                      : const Color(0xFF2A8240).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          // Add extra padding to avoid bottom navigation bar overlap
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String title, int tabIndex) {
    final isSelected = (_tabController.index == 0 && tabIndex == _tabController.index) ||
        (title == 'Strength' && tabIndex == 1);

    return GestureDetector(
      onTap: () {
        if (_tabController.index == 0) {
          setState(() {
            // This would switch between Self-Care and Strength categories for affirmations
          });
        }
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
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF2A8240),
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}