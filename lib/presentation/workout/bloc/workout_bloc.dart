import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/utils/enums/hive_box_keys.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final LocalDbRepository repository;
  WorkoutBloc({
    required this.repository,
  }) : super(WorkoutStateLoading()) {
    on<WorkoutDataRequested>(_onWorkoutDataRequested);
  }
  void _onWorkoutDataRequested(
    WorkoutDataRequested event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final workouts = await repository.read(HiveBoxKey.workouts);
      final exercises = await repository.read(HiveBoxKey.exercises);
      await Future.delayed(Duration(seconds: 2));
      emit(
        WorkoutStateSuccess(
          workouts: workouts.cast<Workout>(),
          exercises: exercises.cast<Exercise>(),
        ),
      );
    } catch (e) {
      emit(
        WorkoutStateFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
