
import '../../domain/entities/plant.dart';

abstract class PlantsEvent {}

class PlantsLoadRequested extends PlantsEvent {}

class PlantsFavoriteToggled extends PlantsEvent {
  final String plantId;

  PlantsFavoriteToggled(this.plantId);
}

class PlantsFilterToggled extends PlantsEvent {}

class PlantsPlantAdded extends PlantsEvent {
  final Plant plant;

  PlantsPlantAdded(this.plant);
}

// Внутренние события для обновления данных из Firestore.
class PlantsDataUpdated extends PlantsEvent {
  final List<Plant> plants;

  PlantsDataUpdated(this.plants);
}

class PlantsFavoritesUpdated extends PlantsEvent {
  final Set<String> favoriteIds;

  PlantsFavoritesUpdated(this.favoriteIds);
}

class PlantsStreamFailed extends PlantsEvent {
  final String message;

  PlantsStreamFailed(this.message);
}
