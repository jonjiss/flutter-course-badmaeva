
import '../../domain/entities/plant.dart';

abstract class PlantsState {}

class PlantsLoadInProgress extends PlantsState {}

class PlantsLoadSuccess extends PlantsState {
  final List<Plant> plants;

  PlantsLoadSuccess(this.plants);
}

class PlantsLoadFailure extends PlantsState {
  final String message;

  PlantsLoadFailure(this.message);
}
