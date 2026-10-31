
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plant.dart';
import '../../data/repositories/plants_repository.dart';
import 'plants_event.dart';
import 'plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  final PlantsRepository _repository;

  StreamSubscription<List<Plant>>? _plantsSubscription;
  StreamSubscription<Set<String>>? _favoritesSubscription;

  List<Plant> _plants = [];
  Set<String> _favoriteIds = {};
  bool _onlyLiked = false;

  bool _plantsLoaded = false;
  bool _favoritesLoaded = false;

  PlantsBloc({
    PlantsRepository? repository,
  })  : _repository = repository ?? PlantsRepository(),
        super(PlantsLoadInProgress()) {
    on<PlantsLoadRequested>(_onLoadRequested);
    on<PlantsFavoriteToggled>(_onFavoriteToggled);
    on<PlantsFilterToggled>(_onFilterToggled);
    on<PlantsPlantAdded>(_onPlantAdded);

    on<PlantsDataUpdated>(_onPlantsDataUpdated);
    on<PlantsFavoritesUpdated>(_onFavoritesUpdated);
    on<PlantsStreamFailed>(_onStreamFailed);
  }

  Future<void> _onLoadRequested(
    PlantsLoadRequested event,
    Emitter<PlantsState> emit,
  ) async {
    emit(PlantsLoadInProgress());

    await _plantsSubscription?.cancel();
    await _favoritesSubscription?.cancel();

    _plantsLoaded = false;
    _favoritesLoaded = false;
    _plants = [];
    _favoriteIds = {};

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(PlantsLoadFailure('Необходимо войти в аккаунт.'));
      return;
    }

    _plantsSubscription = _repository.watchPlants().listen(
      (plants) {
        if (!isClosed) {
          add(PlantsDataUpdated(plants));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(PlantsStreamFailed(
            'Не удалось загрузить каталог. Проверьте подключение.',
          ));
        }
      },
    );

    _favoritesSubscription =
        _repository.watchFavorites(user.uid).listen(
      (favorites) {
        if (!isClosed) {
          add(PlantsFavoritesUpdated(favorites));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(PlantsStreamFailed(
            'Не удалось загрузить избранное. Попробуйте обновить.',
          ));
        }
      },
    );
  }

  void _onPlantsDataUpdated(
    PlantsDataUpdated event,
    Emitter<PlantsState> emit,
  ) {
    _plants = event.plants;
    _plantsLoaded = true;
    _emitSuccess(emit);
  }

  void _onFavoritesUpdated(
    PlantsFavoritesUpdated event,
    Emitter<PlantsState> emit,
  ) {
    _favoriteIds = event.favoriteIds;
    _favoritesLoaded = true;
    _emitSuccess(emit);
  }

  void _emitSuccess(Emitter<PlantsState> emit) {
    if (!_plantsLoaded || !_favoritesLoaded) return;

    emit(
      PlantsLoadSuccess(
        plants: _plants,
        favoriteIds: _favoriteIds,
        onlyLiked: _onlyLiked,
      ),
    );
  }

  void _onStreamFailed(
    PlantsStreamFailed event,
    Emitter<PlantsState> emit,
  ) {
    emit(PlantsLoadFailure(event.message));
  }

  Future<void> _onFavoriteToggled(
    PlantsFavoriteToggled event,
    Emitter<PlantsState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      await _repository.toggleFavorite(user.uid, event.plantId);
    } catch (error) {
      emit(PlantsLoadFailure(
        'Не удалось изменить избранное. Попробуйте ещё раз.',
      ));
    }
  }

  void _onFilterToggled(
    PlantsFilterToggled event,
    Emitter<PlantsState> emit,
  ) {
    _onlyLiked = !_onlyLiked;
    _emitSuccess(emit);
  }

  Future<void> _onPlantAdded(
    PlantsPlantAdded event,
    Emitter<PlantsState> emit,
  ) async {
    try {
      await _repository.addPlant(event.plant);
    } catch (error) {
      emit(PlantsLoadFailure(
        'Не удалось добавить растение. Попробуйте ещё раз.',
      ));
    }
  }

  @override
  Future<void> close() async {
    await _plantsSubscription?.cancel();
    await _favoritesSubscription?.cancel();
    return super.close();
  }
}
