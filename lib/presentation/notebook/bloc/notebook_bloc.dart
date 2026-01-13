import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';
import 'package:uuid/uuid.dart';

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
    on<NotebookWorkoutDeleted>(_onNotebookWorkoutDeleted);
    on<NotebookWorkoutEdited>(_onNotebookWorkoutEdited);
    on<NotebookWorkoutDateAssigned>(_onNotebookWorkoutDateAssigned);
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
        uuid: _getUuid(),
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
        (element) => element.uuid == event.exercise.uuid,
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
            (element) => element.uuid == event.uuid,
          );
          exercises.removeAt(exerciseIdx);

          final workouts = notebookState.savedWorkouts;
          final int workoutIdx = workouts.indexWhere(
            (e) => e.uuid == event.workout!.uuid,
          );
          workouts.replaceRange(workoutIdx, workoutIdx + 1, [
            workouts[workoutIdx].copyWith(exercises: exercises),
          ]);

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
          exerciseIdx = exercises.indexWhere((e) => e.uuid == event.uuid);
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
        uuid: _getUuid(),
        name: event.name,
        exercises: notebookState.unsavedExercises,
        isCompleted: false,
        assignedDates: [],
      );

      await _repository.write(DataBoxKeys.workouts, {
        AppBoxKeys.saved.name: [...notebookState.savedWorkouts, workout],
        AppBoxKeys.unsaved.name: '',
      });
      await _repository.write(DataBoxKeys.exercises, {
        AppBoxKeys.saved.name: [...notebookState.savedWorkouts, workout].fold(
          <String>[],
          (previousValue, element) {
            element.exercises.map((e) => previousValue.add(e.name)).toList();

            return previousValue;
          },
        ),
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

  void _onNotebookWorkoutEdited(
    NotebookWorkoutEdited event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final int idx = notebookState.savedWorkouts.indexWhere(
        (element) => element.uuid == event.workout.uuid,
      );
      notebookState.savedWorkouts.removeAt(idx);
      notebookState.savedWorkouts.insert(idx, event.workout);

      await _repository.write(DataBoxKeys.workouts, {
        AppBoxKeys.saved.name: notebookState.savedWorkouts,
        AppBoxKeys.unsaved.name: notebookState.unsavedWorkoutName,
      });
      emit(notebookState.copyWith(savedWorkouts: notebookState.savedWorkouts));
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookWorkoutDeleted(
    NotebookWorkoutDeleted event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;

      final workoutIdx = notebookState.savedWorkouts.indexWhere(
        (e) => e.uuid == event.uuid,
      );
      notebookState.savedWorkouts.removeAt(workoutIdx);
      await _repository.write(DataBoxKeys.workouts, {
        AppBoxKeys.saved.name: notebookState.savedWorkouts,
        AppBoxKeys.unsaved.name: notebookState.unsavedWorkoutName,
      });

      emit(
        notebookState.copyWith(savedWorkouts: notebookState.savedWorkouts),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookWorkoutDateAssigned(
    NotebookWorkoutDateAssigned event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final workoutIdx = notebookState.savedWorkouts.indexWhere(
        (e) => e.uuid == event.uuid,
      );
      if (!notebookState.savedWorkouts[workoutIdx].assignedDates.contains(
        event.date,
      )) {
        final workout = notebookState.savedWorkouts[workoutIdx];
        notebookState.savedWorkouts.removeAt(workoutIdx);
        notebookState.savedWorkouts.insert(
          workoutIdx,
          workout.copyWith(
            assignedDates: [...workout.assignedDates, event.date],
          ),
        );

        await _repository.write(DataBoxKeys.workouts, {
          AppBoxKeys.saved.name: notebookState.savedWorkouts,
          AppBoxKeys.unsaved.name: notebookState.unsavedWorkoutName,
        });
        emit(
          notebookState.copyWith(savedWorkouts: notebookState.savedWorkouts),
        );
      } else {
        emit(
          notebookState.copyWith(savedWorkouts: notebookState.savedWorkouts),
        );
      }
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }
}

String _getUuid() {
  return Uuid().v4();
}
