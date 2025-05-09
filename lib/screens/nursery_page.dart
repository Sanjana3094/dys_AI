import 'package:flutter/material.dart';
import 'shared_bottom_nav.dart';
import 'floating_chatbot_button.dart';
import 'my_garden_page.dart'; // Import the new garden page

class NurseryPage extends StatefulWidget {
  const NurseryPage({Key? key}) : super(key: key);

  @override
  _NurseryPageState createState() => _NurseryPageState();
}

class _NurseryPageState extends State<NurseryPage> {
  int _wellnessCoins = 250; // Starting coins balance

  // Track purchased plants for garden integration
  List<GardenPlant> _purchasedPlants = [];

  final List<PlantItem> _plantItems = [
    PlantItem(
      name: 'Calm Lavender',
      description: 'Helps reduce anxiety and promotes peaceful sleep',
      growthStage: 2,
      maxGrowthStage: 4,
      coinCost: 50,
      imagePath: 'assets/images/lavendar.jpeg',
    ),
    PlantItem(
      name: 'Energy Sunflower',
      description: 'Boosts mood and increases positive energy',
      growthStage: 3,
      maxGrowthStage: 4,
      coinCost: 75,
      imagePath: 'assets/images/sunflower.jpg',
    ),
    PlantItem(
      name: 'Mindful Mint',
      description: 'Enhances focus and mental clarity',
      growthStage: 1,
      maxGrowthStage: 4,
      coinCost: 40,
      imagePath: 'assets/images/mint.jpeg',
    ),
    PlantItem(
      name: 'Soothing Aloe',
      description: 'Reduces stress and promotes healing',
      growthStage: 4,
      maxGrowthStage: 4,
      coinCost: 90,
      imagePath: 'assets/images/aloe vera.jpg',
    ),
    PlantItem(
      name: 'Resilient Bamboo',
      description: 'Builds emotional resilience and adaptability',
      growthStage: 2,
      maxGrowthStage: 4,
      coinCost: 65,
      imagePath: 'assets/images/bamboo.jpeg',
    ),
    PlantItem(
      name: 'Joyful Jasmine',
      description: 'Enhances feelings of happiness and contentment',
      growthStage: 1,
      maxGrowthStage: 4,
      coinCost: 55,
      imagePath: 'assets/images/jasmine.jpeg',
    ),
    PlantItem(
      name: 'Bonsai',
      description: 'Promotes stability and long-term emotional strength',
      growthStage: 2,
      maxGrowthStage: 5,
      coinCost: 100,
      imagePath: 'assets/images/bonsai.jpg',
    ),
    PlantItem(
      name: 'Serene Lotus',
      description: 'Encourages mindfulness and inner peace',
      growthStage: 0,
      maxGrowthStage: 5,
      coinCost: 120,
      imagePath: 'assets/images/lotus.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPurchasedPlants();
  }

  // Load previously purchased plants from storage
  void _loadPurchasedPlants() {
    // In a real app, this would load from shared preferences or a database
    // For now, we're using an empty list as a starting point
    _purchasedPlants = [];
  }

  void _waterPlant(PlantItem plant) {
    if (plant.growthStage < plant.maxGrowthStage && _wellnessCoins >= 10) {
      setState(() {
        _wellnessCoins -= 10;

        final index = _plantItems.indexWhere((p) => p.name == plant.name);
        if (index != -1) {
          _plantItems[index] = PlantItem(
            name: plant.name,
            description: plant.description,
            growthStage: plant.growthStage + 1,
            maxGrowthStage: plant.maxGrowthStage,
            coinCost: plant.coinCost,
            imagePath: plant.imagePath,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You watered ${plant.name}!'),
          backgroundColor: const Color(0xFF2E8B57),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (_wellnessCoins < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${plant.name} fully grown!'),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _buyNewPlant(PlantItem plant) {
    if (_wellnessCoins >= plant.coinCost) {
      setState(() {
        _wellnessCoins -= plant.coinCost;

        // Add to purchased plants with a random position in garden
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final randomX = (screenWidth * 0.1) + (screenWidth * 0.6 * (DateTime.now().microsecond % 100) / 100);
        final randomY = (screenHeight * 0.2) + (screenHeight * 0.4 * (DateTime.now().millisecond % 100) / 100);

        // Create garden plant from nursery plant
        final gardenPlant = GardenPlant(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: plant.name,
          imagePath: plant.imagePath,
          description: plant.description,
          position: Offset(randomX, randomY),
          growthStage: plant.growthStage,
          maxGrowthStage: plant.maxGrowthStage,
          lastWatered: DateTime.now(),
          needsWater: false,
        );

        _purchasedPlants.add(gardenPlant);
      });

      // Show success message with option to view garden
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(child: Text('Purchased ${plant.name}!')),
              TextButton(
                onPressed: () {
                  _navigateToGarden();
                },
                child: const Text(
                  'VIEW GARDEN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2E8B57),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need ${plant.coinCost} coins!'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Navigate to garden view with purchased plants
  void _navigateToGarden() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GardenScreen(
          initialPlants: _purchasedPlants,
        ),
      ),
    );
  }

  void _showPlantDetails(BuildContext context, PlantItem plant) {
    final color = _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage);

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plant image preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    plant.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Container(
                        width: 80,
                        height: 80,
                        color: color.withOpacity(0.3),
                        child: Center(
                          child: Icon(
                            Icons.spa,
                            color: color,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(plant.description),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Growth: ${plant.growthStage}/${plant.maxGrowthStage}'),
                Text('Cost: ${plant.coinCost} coins'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _waterPlant(plant);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E8B57),
                  ),
                  child: const Text('Water (10 coins)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _buyNewPlant(plant);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                  ),
                  child: Text('Buy (${plant.coinCost})'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForGrowthStage(int stage, int maxStage) {
    if (stage == 0) return Colors.grey;
    if (stage < maxStage / 3) return Colors.amber;
    if (stage < maxStage * 2 / 3) return Colors.green[300]!;
    if (stage < maxStage) return Colors.green[600]!;
    return Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8240),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8240),
        title: const Text(
          'My Nursery',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          // View garden button
          if (_purchasedPlants.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.yard, color: Colors.white),
              onPressed: _navigateToGarden,
              tooltip: 'View Your Garden',
            ),

          // Coins display
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 20,
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
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header info
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Plant Nursery',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Watch plants grow as you improve wellness',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),

                      // Only show if there are purchased plants
                      if (_purchasedPlants.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            onTap: _navigateToGarden,
                            child: Row(
                              children: [
                                Icon(Icons.eco, color: Colors.green[700], size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'You have ${_purchasedPlants.length} plants in your garden',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward, color: Colors.green[700], size: 14),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Collection title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Plant Collection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Plant grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: _plantItems.length,
                  itemBuilder: (context, index) {
                    final plant = _plantItems[index];
                    final color = _getColorForGrowthStage(plant.growthStage, plant.maxGrowthStage);

                    return GestureDetector(
                      onTap: () => _showPlantDetails(context, plant),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Plant image area
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  plant.imagePath,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to colored background with icon if image fails to load
                                    return Container(
                                      color: color.withOpacity(0.3),
                                      child: Center(
                                        child: Icon(
                                          Icons.spa,
                                          color: color,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Plant info
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 2),

                                  LinearProgressIndicator(
                                    value: plant.growthStage / plant.maxGrowthStage,
                                    backgroundColor: Colors.grey[200],
                                    color: color,
                                    minHeight: 4,
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    '${plant.coinCost} coins',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Add extra space at the bottom to account for the navigation bar
              const SizedBox(height: 10),
            ],
          ),

          // Add the floating chatbot button
          const FloatingChatbotButton(),
        ],
      ),
      bottomNavigationBar: SharedBottomNav(
        currentIndex: 2, // Nursery is at index 2
        context: context,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Earn Coins'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Daily Check-in: 15 coins'),
                  Text('• Meditation: 25 coins'),
                  Text('• Journal Entry: 20 coins'),
                  Text('• Breathing Exercise: 15 coins'),
                  Text('• Weekly Goal: 50 coins'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.monetization_on),
      ),
    );
  }
}

class PlantItem {
  final String name;
  final String description;
  final int growthStage;
  final int maxGrowthStage;
  final int coinCost;
  final String imagePath; // Image path for the plant

  PlantItem({
    required this.name,
    required this.description,
    required this.growthStage,
    required this.maxGrowthStage,
    required this.coinCost,
    required this.imagePath,
  });
}