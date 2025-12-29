import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/utils/enums/enum_models.dart';

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
      final workouts = List<Workout>.from(
        await repository.read(EnumModels.workouts),
      );
      final exercises = List<Exercise>.from(
        await repository.read(EnumModels.exercises),
      );
      // TODO remove delay ??
      await Future.delayed(Duration(seconds: 1));
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
      final int maxId = _getUniqModelId(exercises);
      final exercise = Exercise(
        isCompleted: false,
        id: maxId + 1,
        name: event.name,
        weight: double.parse(event.weight),
        repetitions: int.parse(event.repetitions),
        sets: int.parse(event.sets),
      );
      await repository.write(EnumModels.exercises, exercise);
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

  void _onWorkoutExerciseEdited(
    WorkoutExerciseEdited event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final workoutState = state as WorkoutStateSuccess;
      final exercise = workoutState.exercises.firstWhere(
        (element) => element.id == event.id,
      );
      // TODO change in the future
      final modifiedExercise = Exercise(
        id: 9999999,
        isCompleted: event.modyfiedExerciseData['isCompleted'],
        name: event.modyfiedExerciseData['name'],
        weight: double.parse(event.modyfiedExerciseData['weight'].toString()),
        repetitions: int.parse(
          event.modyfiedExerciseData['repetitions'].toString(),
        ),
        sets: int.parse(event.modyfiedExerciseData['sets'].toString()),
      );

      if (modifiedExercise.name != exercise.name ||
          modifiedExercise.weight != exercise.weight ||
          modifiedExercise.repetitions != exercise.repetitions ||
          modifiedExercise.sets != exercise.sets ||
          modifiedExercise.isCompleted != exercise.isCompleted) {
        await repository.update(
          EnumModels.exercises,
          Exercise(
            id: exercise.id,
            isCompleted: modifiedExercise.isCompleted,
            name: modifiedExercise.name,
            weight: modifiedExercise.weight,
            repetitions: modifiedExercise.repetitions,
            sets: modifiedExercise.sets,
          ),
        );

        final exercises = List<Exercise>.from(
          await repository.read(EnumModels.exercises),
        );

        emit(
          WorkoutStateSuccess(
            exercises: exercises,
            workouts: workoutState.workouts,
          ),
        );
      }
    } catch (e) {
      emit(
        WorkoutStateFailure(
          message: 'An error occurred during the edit operation.',
        ),
      );
    }
  }

  void _onWorkoutExerciseDeleted(
    WorkoutExerciseDeleted event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final blocState = state as WorkoutStateSuccess;
      await repository.delete(EnumModels.exercises, event.exercise);
      final exercises = List<Exercise>.from(
        await repository.read(EnumModels.exercises),
      );
      emit(
        WorkoutStateSuccess(
          exercises: exercises,
          workouts: blocState.workouts,
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

  int _getUniqModelId(List<Model> list) {
    return list.isNotEmpty
        ? list
              .cast<Model>()
              .reduce((curr, next) => curr.id > next.id ? curr : next)
              .id
        : 0;
  }
}
