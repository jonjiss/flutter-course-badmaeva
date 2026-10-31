import 'package:flutter/material.dart';

import '../../domain/entities/plant.dart';
import '../widgets/plant_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<int> _likedIds = {};
  bool _onlyLiked = false;

  static const List<Plant> plants = [
    Plant(
      id: 1,
      name: 'Монстера',
      subtitle: 'Тропическая красавица',
      category: PlantCategory.tropical,
      icon: '🌿',
      color: Color(0xFFDCEFD8),
      description: 'Любит яркий рассеянный свет.',
    ),
    Plant(
      id: 2,
      name: 'Фикус',
      subtitle: 'Элегантное дерево',
      category: PlantCategory.foliage,
      icon: '🪴',
      color: Color(0xFFE8E0D0),
      description: 'Подходит для уютного интерьера.',
    ),
    Plant(
      id: 3,
      name: 'Сансевиерия',
      subtitle: 'Неприхотливое растение',
      category: PlantCategory.succulent,
      icon: '🌵',
      color: Color(0xFFD8E8C8),
      description: 'Не требует частого полива.',
    ),
    Plant(
      id: 4,
      name: 'Спатифиллум',
      subtitle: 'Нежный цветок',
      category: PlantCategory.flowering,
      icon: '🌸',
      color: Color(0xFFF0E4E8),
      description: 'Красиво цветёт при хорошем уходе.',
    ),
    Plant(
      id: 5,
      name: 'Орхидея',
      subtitle: 'Изящное цветение',
      category: PlantCategory.flowering,
      icon: '🌺',
      color: Color(0xFFEADCF0),
      description: 'Любит рассеянный свет.',
    ),
    Plant(
      id: 6,
      name: 'Кактус',
      subtitle: 'Маленький пустынный житель',
      category: PlantCategory.succulent,
      icon: '🌵',
      color: Color(0xFFE5E8D0),
      description: 'Поливать нужно редко.',
    ),
    Plant(
      id: 7,
      name: 'Замиокулькас',
      subtitle: 'Долларовое дерево',
      category: PlantCategory.foliage,
      icon: '🍀',
      color: Color(0xFFDCE8D8),
      description: 'Хорошо переносит сухой воздух.',
    ),
    Plant(
      id: 8,
      name: 'Алоэ вера',
      subtitle: 'Полезный суккулент',
      category: PlantCategory.succulent,
      icon: '🌱',
      color: Color(0xFFE0EBD8),
      description: 'Предпочитает солнечные места.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visiblePlants = _onlyLiked
        ? plants.where((plant) => _likedIds.contains(plant.id)).toList()
        : plants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог растений'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('В избранном: ${_likedIds.length}'),
            ),
          ),
          IconButton(
            tooltip: 'Только избранные',
            onPressed: () {
              setState(() {
                _onlyLiked = !_onlyLiked;
              });
            },
            icon: Icon(
              _onlyLiked ? Icons.favorite : Icons.favorite_border,
              color: _onlyLiked ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: visiblePlants.isEmpty
          ? const Center(
              child: Text(
                'Ничего не нашлось',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: visiblePlants.length,
              itemBuilder: (context, index) {
                final plant = visiblePlants[index];

                return PlantCard(
                  plant: plant,
                  isLiked: _likedIds.contains(plant.id),
                  onLikeTap: () {
                    setState(() {
                      if (_likedIds.contains(plant.id)) {
                        _likedIds.remove(plant.id);
                      } else {
                        _likedIds.add(plant.id);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}