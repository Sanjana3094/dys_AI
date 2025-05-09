import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';
import 'nursery_page.dart';

class GardenScreen extends StatefulWidget {
  final List<GardenPlant> initialPlants;

  const GardenScreen({Key? key, this.initialPlants = const []}) : super(key: key);

  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> with TickerProviderStateMixin {
  bool _isEditMode = false;
  bool _isWateringActive = false;
  int _wellnessCoins = 250; // Added wellness coins

  late List<GardenPlant> _userPlants;

  late AnimationController _sunshineController;
  late AnimationController _cloudController;
  late AnimationController _leavesController;

  // Theme colors - forest and earth tones
  final Color _themeGreen = const Color(0xFF2A8240);
  final Color _themeLightGreen = const Color(0xFF3E9B52);
  final Color _themeDarkGreen = const Color(0xFF1E5E2F);
  final Color _themeBrown = const Color(0xFF5D4037);
  final Color _themeLightBrown = const Color(0xFF8D6E63);
  final Color _themeSoil = const Color(0xFF3E2723);

  @override
  void initState() {
    super.initState();
    _userPlants = List.from(widget.initialPlants);

    _sunshineController = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _cloudController = AnimationController(vsync: this, duration: const Duration(seconds: 120))..repeat();
    _leavesController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sunshineController.dispose();
    _cloudController.dispose();
    _leavesController.dispose();
    super.dispose();
  }

  void _waterPlant(GardenPlant plant) {
    if (_wellnessCoins >= 5 && plant.needsWater) {
      final index = _userPlants.indexOf(plant);
      if (index != -1) {
        setState(() {
          _wellnessCoins -= 5; // Deduct coins for watering

          // Update plant with new watering time and potentially increase growth
          _userPlants[index] = GardenPlant(
            id: plant.id,
            name: plant.name,
            imagePath: plant.imagePath,
            description: plant.description,
            position: plant.position,
            growthStage: math.min(plant.growthStage + 1, plant.maxGrowthStage),
            maxGrowthStage: plant.maxGrowthStage,
            lastWatered: DateTime.now(),
            needsWater: false,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You watered ${plant.name}!'),
            backgroundColor: _themeGreen,
            duration: const Duration(seconds: 2),
          ),
        );

        // Show watering animation
        _showWateringEffect(plant);
      }
    } else if (_wellnessCoins < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins! Need 5 coins to water.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${plant.name} doesn\'t need water right now.'),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showWateringEffect(GardenPlant plant) {
    // In a real implementation, you would show water droplet animations here
  }

  void _showPlantDetails(GardenPlant plant) {
    final color = _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plant image with soil border
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _themeBrown.withOpacity(0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        // Soil base
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 25,
                          child: Container(
                            color: _themeBrown,
                          ),
                        ),

                        // Plant image
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            plant.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: _themeGreen.withOpacity(0.2),
                                child: Icon(Icons.spa, color: _themeGreen, size: 40),
                              );
                            },
                          ),
                        ),

                        // Growth stage indicator
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Stage ${plant.growthStage}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Plant details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _themeBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plant.description,
                        style: const TextStyle(
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.eco, color: _themeGreen, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Growth: Stage ${plant.growthStage} of ${plant.maxGrowthStage}',
                            style: TextStyle(
                              fontSize: 14,
                              color: _themeGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: plant.needsWater ? Colors.blue : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            plant.needsWater ? 'Needs water' : 'Well hydrated',
                            style: TextStyle(
                              fontSize: 14,
                              color: plant.needsWater ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Growth progress bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: plant.growthStage / plant.maxGrowthStage,
                  backgroundColor: Colors.grey[200],
                  color: color,
                  minHeight: 10,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: plant.needsWater ? () {
                    Navigator.pop(context);
                    _waterPlant(plant);
                  } : null,
                  icon: const Icon(Icons.water_drop),
                  label: const Text('Water (5 coins)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                if (_isEditMode)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _userPlants.remove(plant);
                      });
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Remove'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForGrowthStage(int currentStage, int maxStage) {
    if (currentStage == 0) return Colors.grey;
    if (currentStage < maxStage / 3) return const Color(0xFFCDAA4C); // Yellowish seedling
    if (currentStage < maxStage * 2 / 3) return const Color(0xFF62A055); // Medium green
    if (currentStage < maxStage) return const Color(0xFF2A8240); // Deep green
    return const Color(0xFF1C5F2C); // Deep forest green (fully grown)
  }

  void _movePlant(GardenPlant plant, Offset newPosition) {
    final index = _userPlants.indexOf(plant);
    if (index != -1) {
      setState(() {
        _userPlants[index] = GardenPlant(
          id: plant.id,
          name: plant.name,
          imagePath: plant.imagePath,
          description: plant.description,
          position: newPosition,
          growthStage: plant.growthStage,
          maxGrowthStage: plant.maxGrowthStage,
          lastWatered: plant.lastWatered,
          needsWater: plant.needsWater,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Garden',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ],
          ),
        ),
        actions: [
          // Coins indicator
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_wellnessCoins',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Edit mode button
          IconButton(
            icon: Icon(_isEditMode ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isEditMode ? 'Edit mode: Drag plants to rearrange' : 'View mode: Tap plants to interact'),
                  backgroundColor: _isEditMode ? Colors.orange : _themeGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Layered garden background
          Container(
            // Soil texture background
            decoration: BoxDecoration(
              color: _themeSoil,
              image: DecorationImage(
                image: const AssetImage('assets/images/garden_soil.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  _themeBrown.withOpacity(0.8),
                  BlendMode.multiply,
                ),
              ),
            ),
          ),

          // Empty garden plots for visual interest when garden is filling up
          _buildGardenPlots(),

          // Sky backdrop at the top
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF87CEEB).withOpacity(0.8),
                    const Color(0xFF87CEEB).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // Animated sun
          Positioned(
            top: -40,
            right: -40,
            child: AnimatedBuilder(
              animation: _sunshineController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _sunshineController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow[300]!.withOpacity(0.8),
                      Colors.yellow[300]!.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Animated clouds
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return Positioned(
                left: -50 + screenSize.width * _cloudController.value,
                top: 30,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Animated foliage in corners
          AnimatedBuilder(
            animation: _leavesController,
            builder: (context, child) {
              return Positioned(
                left: 0,
                top: 120 + (_leavesController.value * 5),
                child: _buildPlantLeaf(_themeLightGreen, 50, 20, -0.2),
              );
            },
          ),

          AnimatedBuilder(
            animation: _leavesController,
            builder: (context, child) {
              return Positioned(
                right: 0,
                top: 180 + (_leavesController.value * -5),
                child: _buildPlantLeaf(_themeGreen, 40, 15, 0.2),
              );
            },
          ),

          // Plants in garden
          for (final plant in _userPlants)
            _isEditMode ? _buildDraggablePlant(plant, screenSize) : _buildTappablePlant(plant),

          // Empty garden message
          if (_userPlants.isEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco, size: 60, color: _themeGreen),
                    const SizedBox(height: 16),
                    const Text(
                      'Your garden is empty',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Visit the nursery to buy plants',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.store),
                      label: const Text('Go to Nursery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _themeGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Watering button
          if (!_isEditMode)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isWateringActive = !_isWateringActive;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isWateringActive ? 'Watering mode: Tap plants to water them' : 'View mode: Tap plants for details'),
                      backgroundColor: _isWateringActive ? Colors.blue : _themeGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                backgroundColor: _isWateringActive ? Colors.blue : _themeGreen,
                child: Icon(_isWateringActive ? Icons.water_drop : Icons.spa, color: Colors.white),
              ),
            ),

          // Chatbot button
          const FloatingChatbotButton(),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 1,
        context: context,
      ),
    );
  }

  Widget _buildGardenPlots() {
    // Creates subtle garden plot markings in the soil
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 9, // 3x3 grid of plots
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF8B4513).withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlantLeaf(Color color, double height, double width, double angle) {
    return Transform.rotate(
      angle: angle,
      child: ClipPath(
        clipper: LeafClipper(),
        child: Container(
          height: height,
          width: width,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTappablePlant(GardenPlant plant) {
    // Scale factor based on growth stage
    final scale = 0.7 + (plant.growthStage * 0.1);

    return Positioned(
      left: plant.position.dx,
      top: plant.position.dy,
      child: GestureDetector(
        onTap: () {
          if (_isWateringActive) {
            _waterPlant(plant);
          } else {
            _showPlantDetails(plant);
          }
        },
        child: Column(
          children: [
            // Plant image with pot/soil
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Soil mound
                Container(
                  width: 60 * scale,
                  height: 30 * scale,
                  decoration: BoxDecoration(
                    color: _themeBrown,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20 * scale),
                      topRight: Radius.circular(20 * scale),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Plant with shadow
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      plant.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.spa,
                          color: _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage),
                          size: 60,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Water droplet indicator if plant needs water
            if (plant.needsWater)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggablePlant(GardenPlant plant, Size screenSize) {
    // Scale factor based on growth stage
    final scale = 0.7 + (plant.growthStage * 0.1);

    return Positioned(
      left: plant.position.dx,
      top: plant.position.dy,
      child: Draggable<String>(
        data: plant.id,
        feedback: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: 0.8,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Soil mound in feedback
                  Container(
                    width: 60 * scale,
                    height: 30 * scale,
                    decoration: BoxDecoration(
                      color: _themeBrown,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20 * scale),
                        topRight: Radius.circular(20 * scale),
                      ),
                    ),
                  ),

                  // Plant image
                  Image.asset(
                    plant.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.spa,
                        color: _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage),
                        size: 60,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: Transform.scale(
            scale: scale,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Soil mound in ghost
                  Container(
                    width: 60 * scale,
                    height: 30 * scale,
                    decoration: BoxDecoration(
                      color: _themeBrown.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20 * scale),
                        topRight: Radius.circular(20 * scale),
                      ),
                    ),
                  ),

                  // Faded plant
                  Image.asset(
                    plant.imagePath,
                    fit: BoxFit.contain,
                    color: Colors.white.withOpacity(0.5),
                    colorBlendMode: BlendMode.modulate,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.spa,
                        color: _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage).withOpacity(0.5),
                        size: 60,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        onDragEnd: (details) {
          // Make sure plant is within screen bounds
          final newX = math.max(0.0, math.min(details.offset.dx, screenSize.width - 100.0));
          final newY = math.max(70.0, math.min(details.offset.dy, screenSize.height - 150.0));

          _movePlant(plant, Offset(newX, newY));
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Plant with soil mound
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Soil mound
                Container(
                  width: 60 * scale,
                  height: 30 * scale,
                  decoration: BoxDecoration(
                    color: _themeBrown,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20 * scale),
                      topRight: Radius.circular(20 * scale),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Plant with shadow
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          plant.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.spa,
                              color: _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage),
                              size: 60,
                            );
                          },
                        ),

                        // Edit mode indicator
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.drag_indicator,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GardenPlant {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final Offset position;
  final int growthStage;
  final int maxGrowthStage;
  final DateTime lastWatered;
  final bool needsWater;

  const GardenPlant({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.position,
    required this.growthStage,
    required this.maxGrowthStage,
    required this.lastWatered,
    required this.needsWater,
  });
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