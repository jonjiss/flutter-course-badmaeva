
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/plant.dart';
import '../widgets/plant_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<String> _likedIds = {};
  final TextEditingController _nameController =
      TextEditingController();

  final CollectionReference<Map<String, dynamic>> _plantsCollection =
      FirebaseFirestore.instance.collection('plants');

  bool _onlyLiked = false;
  bool _isAdding = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Добавление нового растения в Firestore.
  Future<void> _addPlant() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите название растения'),
        ),
      );
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      final newPlant = Plant(
        id: '',
        name: name,
        subtitle: 'Новое растение',
        category: PlantCategory.foliage,
        description: '',
        icon: '🌱',
        color: Colors.green,
      );

      await _plantsCollection.add(newPlant.toJson());

      if (!mounted) return;

      _nameController.clear();

      setState(() {
        _onlyLiked = false;
        _isAdding = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Растение успешно добавлено!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isAdding = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось добавить растение: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _onlyLiked
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _onlyLiked ? Colors.red : null,
            ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название растения',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isAdding ? null : _addPlant,
                  child: _isAdding
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Добавить'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _plantsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ошибка загрузки растений: ${snapshot.error}',
                    ),
                  );
                }

                final plants = snapshot.data!.docs
                    .map((doc) => Plant.fromFirestore(doc))
                    .toList();

                final visiblePlants = _onlyLiked
                    ? plants
                        .where(
                          (plant) => _likedIds.contains(plant.id),
                        )
                        .toList()
                    : plants;

                if (visiblePlants.isEmpty) {
                  return const Center(
                    child: Text(
                      'Ничего не нашлось',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
