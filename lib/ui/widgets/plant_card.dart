import 'package:flutter/material.dart';

import '../../domain/entities/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final bool isLiked;
  final VoidCallback onLikeTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.isLiked,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: plant.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    plant.icon,
                    style: const TextStyle(fontSize: 42),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    onPressed: onLikeTap,
                    icon: Icon(
                      isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(plant.subtitle),
                  if (plant.description != null) ...[
                    const SizedBox(height: 4),
                    Text(plant.description!),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _categoryName(plant.category),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
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

  String _categoryName(PlantCategory category) {
    switch (category) {
      case PlantCategory.tropical:
        return 'Тропическое';
      case PlantCategory.succulent:
        return 'Суккулент';
      case PlantCategory.flowering:
        return 'Цветущее';
      case PlantCategory.foliage:
        return 'Декоративно-лиственное';
    }
  }
}