
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plant.dart';
import 'plants_event.dart';
import 'plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  PlantsBloc() : super(PlantsLoadInProgress()) {
    on<PlantsLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    PlantsLoadRequested event,
    Emitter<PlantsState> emit,
  ) async {
    emit(PlantsLoadInProgress());

    await emit.forEach<QuerySnapshot<Map<String, dynamic>>>(
      FirebaseFirestore.instance.collection('plants').snapshots(),
      onData: (snapshot) {
        final plants = snapshot.docs
            .map((doc) => Plant.fromFirestore(doc))
            .toList();

        return PlantsLoadSuccess(plants);
      },
      onError: (error, stackTrace) {
        return PlantsLoadFailure(
          'Не удалось загрузить каталог. Проверьте подключение и попробуйте ещё раз.',
        );
      },
    );
  }
}
