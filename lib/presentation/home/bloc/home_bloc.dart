import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/utils/enums.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocalDbRepository repository;
  HomeBloc({
    required this.repository,
  }) : super(HomeStateLoading()) {
    on<HomeDataRequested>(_onHomeDataRequested);
  }
  void _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final workouts = await repository.read(HiveBoxKey.workouts);
      final exercises = await repository.read(HiveBoxKey.exercises);
      emit(
        HomeStateSuccess(
          workouts: workouts.cast<Workout>(),
          exercises: exercises.cast<Exercise>(),
        ),
      );
    } catch (e) {
      emit(
        HomeStateFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
