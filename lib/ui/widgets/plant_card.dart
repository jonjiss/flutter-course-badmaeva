
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/plants_bloc.dart';
import '../../domain/entities/plant.dart';
import '../screens/plant_details_screen.dart';

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

  String _categoryName(PlantCategory category) {
    switch (category) {
      case PlantCategory.foliage:
        return 'Декоративно-лиственные';
      case PlantCategory.flowering:
        return 'Цветущие';
      case PlantCategory.succulent:
        return 'Суккуленты';
      case PlantCategory.tropical:
        return 'Тропические';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (detailsContext) {
                return BlocProvider.value(
                  value: context.read<PlantsBloc>(),
                  child: PlantDetailsScreen(
                    plant: plant,
                  ),
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: plant.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    plant.icon,
                    style: const TextStyle(fontSize: 38),
                  ),
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
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(plant.subtitle),
                    const SizedBox(height: 6),
                    Text(
                      _categoryName(plant.category),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onLikeTap,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
