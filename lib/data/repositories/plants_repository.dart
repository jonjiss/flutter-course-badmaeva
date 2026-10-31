
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/plant.dart';

class PlantsRepository {
  final FirebaseFirestore _firestore;

  PlantsRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _plants =>
      _firestore.collection('plants');

  // Получение каталога с обновлениями в реальном времени.
  Stream<List<Plant>> watchPlants() {
    return _plants.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Plant.fromFirestore(doc))
          .toList(),
    );
  }

  // Получение избранного конкретного пользователя.
  Stream<Set<String>> watchFavorites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();

      if (data == null) {
        return <String>{};
      }

      final favorites =
          data['favoritePlantIds'] as List<dynamic>? ?? [];

      return favorites.map((id) => id.toString()).toSet();
    });
  }

  // Переключение лайка и сохранение в Firestore.
  Future<void> toggleFavorite(
    String userId,
    String plantId,
  ) async {
    final userDocument =
        _firestore.collection('users').doc(userId);

    final snapshot = await userDocument.get();

    final favorites = List<String>.from(
      snapshot.data()?['favoritePlantIds'] ?? [],
    );

    if (favorites.contains(plantId)) {
      favorites.remove(plantId);
    } else {
      favorites.add(plantId);
    }

    await userDocument.set(
      {'favoritePlantIds': favorites},
      SetOptions(merge: true),
    );
  }

  // Добавление растения.
  Future<void> addPlant(Plant plant) async {
    await _plants.add(plant.toJson());
  }
}
