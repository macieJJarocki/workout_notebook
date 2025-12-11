import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
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
    on<WorkoutExerciseCreated>(_onWorkoutExerciseCreated);
  }
  void _onWorkoutDataRequested(
    WorkoutDataRequested event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final workouts = await repository.read(HiveBoxKey.workouts);
      final exercises = await repository.read(HiveBoxKey.exercises);
      // TODO remove delay ??
      await Future.delayed(Duration(seconds: 2));
      emit(
        WorkoutStateSuccess(
          workouts: workouts,
          exercises: exercises,
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

  void _onWorkoutExerciseCreated(
    WorkoutExerciseCreated event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final exercises = (state as WorkoutStateSuccess).exercises;
      final int maxWorkoutsId = exercises.isNotEmpty
          ? exercises.reduce((curr, next) => curr.id > next.id ? curr : next).id
          : 0;
      final exercise = Exercise(
        id: maxWorkoutsId + 1,
        name: event.name,
        weight: double.parse(event.weight),
        repetitions: int.parse(event.repetitions),
        sets: int.parse(event.sets),
      );
      await repository.write(HiveBoxKey.exercises, exercise);
      // TODO emit state or call _onWorkoutDataRequested()??
      emit(WorkoutStateSuccess(exercises: [...exercises, exercise]));
    } catch (e) {
      // TODO replace error msg
      emit(WorkoutStateFailure(message: 'lorem ipsum'));
    }
  }
}
