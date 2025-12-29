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
    on<WorkoutCreated>(_onWorkoutCreated);
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
      final unsavedExercises = List<Exercise>.from(
        await repository.read(EnumModels.appData),
      );
      emit(
        WorkoutStateSuccess(
          workouts: workouts,
          exercises: exercises,
          unsavedExercises: unsavedExercises,
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
      final exercises = blocState.unsavedExercises;

      final exercise = Exercise(
        isCompleted: false,
        id: _getUniqModelId(exercises) + 1,
        name: event.name,
        weight: double.parse(event.weight),
        repetitions: int.parse(event.repetitions),
        sets: int.parse(event.sets),
      );
      await repository.write(EnumModels.appData, exercise);
      emit(
        WorkoutStateSuccess(
          exercises: blocState.exercises,
          workouts: blocState.workouts,
          unsavedExercises: [...blocState.unsavedExercises, exercise],
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
      final blocState = state as WorkoutStateSuccess;
      final modifiedExercise = event.modyfiedExerciseData;
      final exercise = blocState.unsavedExercises.firstWhere(
        (element) => element.id == event.id,
      );
      if (modifiedExercise['name'] != exercise.name ||
          modifiedExercise['weight'] != exercise.weight ||
          modifiedExercise['repetitions'] != exercise.repetitions ||
          modifiedExercise['sets'] != exercise.sets ||
          modifiedExercise['isCompleted'] != exercise.isCompleted) {
        await repository.update(
          EnumModels.appData,
          Exercise(
            id: exercise.id,
            name: modifiedExercise['name'],
            weight: double.parse(modifiedExercise['weight']),
            repetitions: int.parse(modifiedExercise['repetitions']),
            sets: int.parse(modifiedExercise['sets']),
            isCompleted: modifiedExercise['isCompleted'],
          ),
        );

        final exercises = List<Exercise>.from(
          await repository.read(EnumModels.appData),
        );

        emit(
          WorkoutStateSuccess(
            exercises: blocState.exercises,
            workouts: blocState.workouts,
            unsavedExercises: exercises,
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
      await repository.delete(EnumModels.appData, event.exercise);
      final exercises = List<Exercise>.from(
        await repository.read(EnumModels.appData),
      );
      emit(
        WorkoutStateSuccess(
          exercises: blocState.exercises,
          workouts: blocState.workouts,
          unsavedExercises: exercises,
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

  void _onWorkoutCreated(
    WorkoutCreated event,
    Emitter<WorkoutState> emit,
  ) async {
    try {
      final blocState = state as WorkoutStateSuccess;
      final workout = Workout(
        id: _getUniqModelId(blocState.workouts),
        isCompleted: false,
        exercises: event.exercises
      );
      await repository.write(EnumModels.workouts, workout);
      emit(
        WorkoutStateSuccess(
          workouts: [...blocState.workouts, workout],
          exercises: blocState.exercises,
          unsavedExercises: [],
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

  int _getUniqModelId(List<Model> list) {
    return list.isNotEmpty
        ? list
              .cast<Model>()
              .reduce((curr, next) => curr.id > next.id ? curr : next)
              .id
        : 0;
  }
}
