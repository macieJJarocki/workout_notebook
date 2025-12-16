import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/utils/enums/hive_box_keys.dart';
import 'package:flutter/foundation.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final LocalDbRepository repository;
  WorkoutBloc({
    required this.repository,
  }) : super(WorkoutStateLoading()) {
    on<WorkoutDataRequested>(_onWorkoutDataRequested);
    on<WorkoutExerciseCreated>(_onWorkoutExerciseCreated);
    on<WorkoutExerciseDeleted>(_onWorkoutExerciseDeleted);
    on<WorkoutExerciseEdited>(_onWorkoutExerciseEdited);
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
      final blocState = state as WorkoutStateSuccess;
      final exercises = blocState.exercises;
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
      emit(
        WorkoutStateSuccess(
          exercises: [...exercises, exercise],
          workouts: blocState.workouts,
        ),
      );
    } catch (e) {
      emit(
        WorkoutStateFailure(
          message: 'An error occurred during the write operation.',
        ),
      );
    }
  }

  void _onWorkoutExerciseDeleted(
    WorkoutExerciseDeleted event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final workoutState = state as WorkoutStateSuccess;
      await repository.delete(HiveBoxKey.exercises, event.exercise);
      final exercises = await repository.read(HiveBoxKey.exercises);
      emit(
        WorkoutStateSuccess(
          exercises: exercises,
          workouts: workoutState.workouts,
        ),
      );
    } catch (e) {
      emit(
        WorkoutStateFailure(
          message: 'An error occurred during the delete operation.',
        ),
      );
    }
  }

  void _onWorkoutExerciseEdited(
    WorkoutExerciseEdited event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final workoutState = state as WorkoutStateSuccess;
      final exercise = event.exercise;
      final modifiedExercise = Exercise(
        id: 9999999,
        name: event.modyfiedExerciseData['name'],
        weight: double.parse(event.modyfiedExerciseData['weight']),
        repetitions: int.parse(event.modyfiedExerciseData['repetitions']),
        sets: int.parse(event.modyfiedExerciseData['sets']),
      );

      if (modifiedExercise.name != exercise.name ||
          modifiedExercise.weight != exercise.weight ||
          modifiedExercise.repetitions != exercise.repetitions ||
          modifiedExercise.sets != exercise.sets) {
        await repository.update(
          HiveBoxKey.exercises,
          Exercise(
            id: exercise.id,
            name: modifiedExercise.name,
            weight: modifiedExercise.weight,
            repetitions: modifiedExercise.repetitions,
            sets: modifiedExercise.sets,
          ),
        );
        final exercises = await repository.read(HiveBoxKey.exercises);
        emit(
          WorkoutStateSuccess(
            exercises: exercises,
            workouts: workoutState.workouts,
          ),
        );
      }
      // TODO remove debugPrint
      debugPrint('The data has not changed');
    } catch (e) {
      emit(
        WorkoutStateFailure(
          message: 'An error occurred during the edit operation.',
        ),
      );
    }
  }
}
