
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/plant.dart';
import '../widgets/plant_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const String _baseUrl =
      'https://6ae5e29b877d34ccafc28161.mockapi.io';

  final Set<int> _likedIds = {};
  final TextEditingController _nameController =
      TextEditingController();

  List<Plant> _plants = [];
  bool _onlyLiked = false;
  bool _isLoading = true;
  bool _isAdding = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Загрузка растений с сервера (GET)
  Future<void> _loadPlants() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/plants'),
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }

      final List<dynamic> data = jsonDecode(response.body);

      final plants = data
          .map(
            (item) => Plant.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error =
            'Не удалось загрузить растения. Проверьте интернет.';
        _isLoading = false;
      });
    }
  }

  // Добавление нового растения на сервер (POST)
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
        id: 0,
        name: name,
        subtitle: 'Новое растение',
        category: PlantCategory.foliage,
        description: '',
        icon: '🌱',
        color: Colors.green,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/plants'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newPlant.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception(
          'Ошибка добавления: ${response.statusCode}',
        );
      }

      final addedPlant = Plant.fromJson(
        jsonDecode(response.body),
      );

      if (!mounted) return;

      setState(() {
        _plants.insert(0, addedPlant);
        _onlyLiked = false;
        _isAdding = false;
      });

      _nameController.clear();

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
        const SnackBar(
          content: Text('Не удалось добавить растение'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visiblePlants = _onlyLiked
        ? _plants
            .where((plant) => _likedIds.contains(plant.id))
            .toList()
        : _plants;

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
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadPlants,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : Column(
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
                            onPressed:
                                _isAdding ? null : _addPlant,
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
                      child: visiblePlants.isEmpty
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
                                  isLiked:
                                      _likedIds.contains(plant.id),
                                  onLikeTap: () {
                                    setState(() {
                                      if (_likedIds
                                          .contains(plant.id)) {
                                        _likedIds.remove(plant.id);
                                      } else {
                                        _likedIds.add(plant.id);
                                      }
                                    });
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
