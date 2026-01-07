import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';

part 'notebook_event.dart';
part 'notebook_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  final LocalDBRepository _repository;
  NotebookBloc({
    required LocalDBRepository repository,
  }) : _repository = repository,
       super(NotebookInitial()) {
    on<NotebookDataRequested>(_onNotebookDataRequested);
    on<NotebookWorkoutCreated>(_onNotebookWorkoutCreated);
    on<NotebookWorkoutNameRequested>(_onNotebookWorkoutNameRequested);
    on<NotebookExerciseCreated>(_onNotebookExerciseCreated);
    on<NotebookExerciseEdited>(_onNotebookExerciseEdited);
    on<NotebookExerciseDeleted>(_onNotebookExerciseDeleted);
  }

  void _onNotebookDataRequested(
    NotebookDataRequested event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final exerciseData = await _repository.read(DataBoxKeys.exercises);
      final workoutData = await _repository.read(DataBoxKeys.workouts);
      emit(
        NotebookSuccess(
          savedWorkouts: List<Workout>.from(workoutData[AppBoxKeys.saved.name]),
          unsavedWorkoutName: workoutData[AppBoxKeys.unsaved.name],
          savedExercisesNames:
              exerciseData[AppBoxKeys.saved.name] as List<String>,
          unsavedExercises: List<Exercise>.from(
            exerciseData[AppBoxKeys.unsaved.name],
          ),
        ),
      );
    } catch (e) {
      emit(
        NotebookFailure(e.toString()),
      );
    }
  }

  void _onNotebookWorkoutNameRequested(
    NotebookWorkoutNameRequested event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      await _repository.write(DataBoxKeys.workouts, {
        AppBoxKeys.saved.name: notebookState.savedWorkouts,
        AppBoxKeys.unsaved.name: event.name,
      });
      emit(
        notebookState.copyWith(unsavedWorkoutName: event.name),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookExerciseCreated(
    NotebookExerciseCreated event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final exercise = Exercise(
        // TODO fix method
        id: _getUniqModelId([]),
        isCompleted: false,
        name: event.name,
        weight: double.tryParse(event.weight) as double,
        repetitions: int.tryParse(event.repetitions) as int,
        sets: int.tryParse(event.sets) as int,
      );

      await _repository.write(DataBoxKeys.exercises, {
        AppBoxKeys.saved.name: notebookState.savedExercisesNames,
        AppBoxKeys.unsaved.name: [...notebookState.unsavedExercises, exercise],
      });
      emit(
        notebookState.copyWith(
          unsavedExercises: [...notebookState.unsavedExercises, exercise],
        ),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookExerciseEdited(
    NotebookExerciseEdited event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final int idx = notebookState.unsavedExercises.indexWhere(
        (element) => element.id == event.exercise.id,
      );
      notebookState.unsavedExercises.removeAt(idx);
      notebookState.unsavedExercises.insert(idx, event.exercise);

      await _repository.write(DataBoxKeys.exercises, {
        AppBoxKeys.saved.name: notebookState.savedExercisesNames,
        AppBoxKeys.unsaved.name: notebookState.unsavedExercises,
      });
      emit(
        notebookState.copyWith(
          unsavedExercises: notebookState.unsavedExercises,
        ),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookExerciseDeleted(
    NotebookExerciseDeleted event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      late final List<Exercise> exercises;
      late final int exerciseIdx;
      late final DataBoxKeys key;
      final notebookState = state as NotebookSuccess;

      switch (event.workout.runtimeType) {
        case Workout _:
          exercises = event.workout!.exercises;
          exerciseIdx = exercises.indexWhere(
            (element) => element.id == event.id,
          );
          exercises.removeAt(exerciseIdx);

          final workouts = notebookState.savedWorkouts;
          final int workoutIdx = workouts.indexWhere(
            (e) => e.id == event.workout!.id,
          );
          // TODO remove debugprint
          debugPrint(workouts.toString());
          workouts.replaceRange(workoutIdx, workoutIdx + 1, [
            workouts[workoutIdx].copyWith(exercises: exercises),
          ]);
          // TODO remove debugprint
          debugPrint(workouts.toString());

          key = DataBoxKeys.workouts;
          await _repository.write(key, {
            AppBoxKeys.saved.name: workouts,
            AppBoxKeys.unsaved.name: notebookState.unsavedWorkoutName,
          });
          emit(
            notebookState.copyWith(savedWorkouts: workouts),
          );

        default:
          exercises = notebookState.unsavedExercises;
          exerciseIdx = exercises.indexWhere((e) => e.id == event.id);
          key = DataBoxKeys.exercises;
          exercises.removeAt(exerciseIdx);
          await _repository.write(key, {
            AppBoxKeys.saved.name: notebookState.savedExercisesNames,
            AppBoxKeys.unsaved.name: exercises,
          });
          emit(
            notebookState.copyWith(
              unsavedExercises: notebookState.unsavedExercises,
            ),
          );
      }
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookWorkoutCreated(
    NotebookWorkoutCreated event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final Workout workout = Workout(
        // TODO fix method
        id: _getUniqModelId([]),
        name: event.name,
        exercises: notebookState.unsavedExercises,
        isCompleted: false,
      );

      await _repository.write(DataBoxKeys.workouts, {
        AppBoxKeys.saved.name: [...notebookState.savedWorkouts, workout],
        AppBoxKeys.unsaved.name: '',
      });
      await _repository.write(DataBoxKeys.exercises, {
        AppBoxKeys.saved.name: [
          ...notebookState.savedWorkouts,
          workout,
        ].map((e) => e.name).toList(),
        AppBoxKeys.unsaved.name: [],
      });
      emit(
        notebookState.copyWith(
          savedWorkouts: [...notebookState.savedWorkouts, workout],
          unsavedWorkoutName: '',
          unsavedExercises: [],
          savedExercisesNames: [
            ...notebookState.savedExercisesNames,
            ...notebookState.unsavedExercises.map((e) => e.name),
          ],
        ),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }
}

//  TODO Fix id for the model
// TODO in future change to return uuid
int _getUniqModelId(List<Model> list) {
  // return list.isNotEmpty
  //     ? list
  //           .cast<Model>()
  //           .reduce((curr, next) => curr.id > next.id ? curr : next)
  //           .id
  //     : 0;
  return Random().nextInt(9999999);
}
