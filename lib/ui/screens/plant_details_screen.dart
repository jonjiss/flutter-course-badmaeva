
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/plants_bloc.dart';
import '../../bloc/plants_event.dart';
import '../../bloc/plants_state.dart';
import '../../domain/entities/plant.dart';

class PlantDetailsScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailsScreen({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О растении'),
        actions: [
          BlocBuilder<PlantsBloc, PlantsState>(
            builder: (context, state) {
              final isLiked = state is PlantsLoadSuccess &&
                  state.favoriteIds.contains(plant.id);

              return IconButton(
                tooltip: isLiked
                    ? 'Убрать из избранного'
                    : 'Добавить в избранное',
                onPressed: state is PlantsLoadSuccess
                    ? () {
                        context.read<PlantsBloc>().add(
                              PlantsFavoriteToggled(plant.id),
                            );
                      }
                    : null,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: plant.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  plant.icon,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              plant.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              plant.subtitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            const Text(
              'Категория',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              plant.category.name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Описание',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              plant.description?.isNotEmpty == true
                  ? plant.description!
                  : 'Описание пока не добавлено.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
