
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/plants_bloc.dart';
import '../../bloc/plants_event.dart';
import '../../bloc/plants_state.dart';
import '../../domain/entities/plant.dart';
import '../widgets/plant_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  void _showAddPlantDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Новое растение'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Название растения',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Введите название растения'),
                    ),
                  );
                  return;
                }

                final newPlant = Plant(
                  id: '',
                  name: name,
                  subtitle: 'Новое растение',
                  category: PlantCategory.foliage,
                  description: '',
                  icon: '🌱',
                  color: Colors.green,
                );

                context.read<PlantsBloc>().add(
                      PlantsPlantAdded(newPlant),
                    );

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Растение добавляется в каталог'),
                  ),
                );
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог растений'),
        actions: [
          BlocBuilder<PlantsBloc, PlantsState>(
            builder: (context, state) {
              if (state is! PlantsLoadSuccess) {
                return const SizedBox.shrink();
              }

              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'В избранном: ${state.favoriteIds.length}',
                  ),
                ),
              );
            },
          ),
          BlocBuilder<PlantsBloc, PlantsState>(
            builder: (context, state) {
              final onlyLiked =
                  state is PlantsLoadSuccess && state.onlyLiked;

              return IconButton(
                tooltip: 'Только избранные',
                onPressed: () {
                  context.read<PlantsBloc>().add(
                        PlantsFilterToggled(),
                      );
                },
                icon: Icon(
                  onlyLiked ? Icons.favorite : Icons.favorite_border,
                  color: onlyLiked ? Colors.red : null,
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Выйти',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Добавить растение',
        onPressed: () => _showAddPlantDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PlantsBloc, PlantsState>(
        builder: (context, state) {
          if (state is PlantsLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PlantsLoadFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PlantsBloc>().add(
                            PlantsLoadRequested(),
                          );
                    },
                    child: const Text('Обновить'),
                  ),
                ],
              ),
            );
          }

          if (state is PlantsLoadSuccess) {
            final visiblePlants = state.visiblePlants;

            if (visiblePlants.isEmpty) {
              return Center(
                child: Text(
                  state.onlyLiked
                      ? 'В избранном пока нет растений'
                      : 'Каталог пока пуст',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: visiblePlants.length,
              itemBuilder: (context, index) {
                final plant = visiblePlants[index];

                return PlantCard(
                  plant: plant,
                  isLiked: state.favoriteIds.contains(plant.id),
                  onLikeTap: () {
                    context.read<PlantsBloc>().add(
                          PlantsFavoriteToggled(plant.id),
                        );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
