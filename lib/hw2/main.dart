
import 'package:flutter/material.dart';

void main() {
  runApp(const PlantCatalogApp());
}

class PlantCatalogApp extends StatelessWidget {
  const PlantCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мир растений',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F7F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF477A50),
        ),
        useMaterial3: true,
      ),
      home: const PlantCatalogScreen(),
    );
  }
}

class Plant {
  final String name;
  final String description;
  final String icon;
  final Color color;

  const Plant({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class PlantCatalogScreen extends StatelessWidget {
  const PlantCatalogScreen({super.key});

  static const List<Plant> plants = [
    Plant(
      name: 'Монстера',
      description: 'Крупные листья с красивыми прорезями',
      icon: '🌿',
      color: Color(0xFFB8D8B0),
    ),
    Plant(
      name: 'Фикус',
      description: 'Элегантное дерево для уютного дома',
      icon: '🪴',
      color: Color(0xFFD8C6A5),
    ),
    Plant(
      name: 'Сансевиерия',
      description: 'Неприхотливое растение с длинными листьями',
      icon: '🌱',
      color: Color(0xFFC5D5A5),
    ),
    Plant(
      name: 'Спатифиллум',
      description: 'Нежные белые цветы и зелёные листья',
      icon: '🌸',
      color: Color(0xFFE6D6C5),
    ),
    Plant(
      name: 'Орхидея',
      description: 'Изящный цветок для украшения комнаты',
      icon: '🌺',
      color: Color(0xFFE5C5D9),
    ),
    Plant(
      name: 'Кактус',
      description: 'Маленькое растение, которое любит солнце',
      icon: '🌵',
      color: Color(0xFFC5DCCB),
    ),
    Plant(
      name: 'Замиокулькас',
      description: 'Глянцевые листья и неприхотливый характер',
      icon: '🍃',
      color: Color(0xFFB7CBAA),
    ),
    Plant(
      name: 'Алоэ вера',
      description: 'Суккулент с мясистыми листьями',
      icon: '🌾',
      color: Color(0xFFD5DDB5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF477A50),
        foregroundColor: Colors.white,
        title: const Text(
          'Мир комнатных растений',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return PlantCard(plant: plants[index]);
        },
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: plant.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        plant.icon,
                        style: const TextStyle(fontSize: 54),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF31583A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plant.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(
                        Icons.local_florist,
                        color: Color(0xFF477A50),
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Комнатные растения',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF477A50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
