
import '../../domain/entities/plant.dart';

abstract class PlantsState {}

class PlantsLoadInProgress extends PlantsState {}

class PlantsLoadSuccess extends PlantsState {
  final List<Plant> plants;
  final Set<String> favoriteIds;
  final bool onlyLiked;

  PlantsLoadSuccess({
    required this.plants,
    this.favoriteIds = const {},
    this.onlyLiked = false,
  });

  List<Plant> get visiblePlants {
    if (!onlyLiked) {
      return plants;
    }

    return plants
        .where((plant) => favoriteIds.contains(plant.id))
        .toList();
  }

  PlantsLoadSuccess copyWith({
    List<Plant>? plants,
    Set<String>? favoriteIds,
    bool? onlyLiked,
  }) {
    return PlantsLoadSuccess(
      plants: plants ?? this.plants,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      onlyLiked: onlyLiked ?? this.onlyLiked,
    );
  }
}

class PlantsLoadFailure extends PlantsState {
  final String message;

  PlantsLoadFailure(this.message);
}
