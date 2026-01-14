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
    on<NotebookWorkoutsPlanDateAssigned>(_onNotebookWorkoutsPlanDateAssigned);
    on<NotebookWorkoutsPlanDeleted>(_onNotebookWorkoutsPlanDeleted);
    on<NotebookWorkoutsPlanEdited>(_onNotebookWorkoutsPlanEdited);
  }

  // TODO refactor NotebookBloc to unify method for DateBoxKeys !!!!!!!!!!!!

  void _onNotebookDataRequested(
    NotebookDataRequested event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final exerciseData = await _repository.read(DataBoxKeys.exercises);
      final workoutData = await _repository.read(DataBoxKeys.workouts);
      final otherData = await _repository.read(DataBoxKeys.other);
      emit(
        NotebookSuccess(
          savedWorkouts: List<Workout>.from(
            workoutData[AppWorkoutKeys.saved.name],
          ),
          unsavedWorkoutName: workoutData[AppWorkoutKeys.unsaved.name],
          savedExercisesNames:
              exerciseData[AppWorkoutKeys.saved.name] as List<String>,
          unsavedExercises: List<Exercise>.from(
            exerciseData[AppWorkoutKeys.unsaved.name],
          ),
          workoutsAssigned: Map<String, dynamic>.from(
            otherData[AppOtherKeys.dateWorkoutsAsssigned.name],
          ).map((key, value) => MapEntry(key, List<Workout>.from(value))),
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
        AppWorkoutKeys.saved.name: notebookState.savedWorkouts,
        AppWorkoutKeys.unsaved.name: event.name,
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
        AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
        AppWorkoutKeys.unsaved.name: [
          ...notebookState.unsavedExercises,
          exercise,
        ],
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
        AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
        AppWorkoutKeys.unsaved.name: notebookState.unsavedExercises,
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
            AppWorkoutKeys.saved.name: workouts,
            AppWorkoutKeys.unsaved.name: notebookState.unsavedWorkoutName,
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
            AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
            AppWorkoutKeys.unsaved.name: exercises,
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
        AppWorkoutKeys.saved.name: [...notebookState.savedWorkouts, workout],
        AppWorkoutKeys.unsaved.name: '',
      });
      await _repository.write(DataBoxKeys.exercises, {
        AppWorkoutKeys.saved.name: [...notebookState.savedWorkouts, workout]
            .fold(
              <String>[],
              (previousValue, element) {
                element.exercises
                    .map((e) => previousValue.add(e.name))
                    .toList();

                return previousValue;
              },
            ),
        AppWorkoutKeys.unsaved.name: [],
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
        AppWorkoutKeys.saved.name: notebookState.savedWorkouts,
        AppWorkoutKeys.unsaved.name: notebookState.unsavedWorkoutName,
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
        AppWorkoutKeys.saved.name: notebookState.savedWorkouts,
        AppWorkoutKeys.unsaved.name: notebookState.unsavedWorkoutName,
      });

      emit(
        notebookState.copyWith(savedWorkouts: notebookState.savedWorkouts),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookWorkoutsPlanDateAssigned(
    NotebookWorkoutsPlanDateAssigned event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final Map<String, List<Workout>> workoutsAssigned =
          notebookState.workoutsAssigned;

      var workout =
          notebookState.savedWorkouts[notebookState.savedWorkouts.indexWhere(
            (e) => e.uuid == event.workout.uuid,
          )];

      final String date = event.date.toString();

      if (!(workoutsAssigned.containsKey(date))) {
        workout = workout.copyWith(uuid: _getUuid());
        workoutsAssigned[date] = [workout];
      } else {
        switch (workoutsAssigned[date]!.any(
          (element) => element.name == event.workout.name,
        )) {
          case false:
            workout = workout.copyWith(uuid: _getUuid());
            workoutsAssigned[date]!.add(workout);
          case true:
        }
      }
      await _repository.write(DataBoxKeys.other, {
        AppOtherKeys.dateWorkoutsAsssigned.name: workoutsAssigned,
      });
      emit(notebookState.copyWith(workoutsAssigned: workoutsAssigned));
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookWorkoutsPlanDeleted(
    NotebookWorkoutsPlanDeleted event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final workouts = notebookState.workoutsAssigned[event.date.toString()];
      final int idx = workouts!.indexWhere((w) => w.uuid == event.workout.uuid);

      workouts.removeAt(idx);

      notebookState.workoutsAssigned[event.date.toString()] = workouts;

      await _repository.write(DataBoxKeys.other, {
        AppOtherKeys.dateWorkoutsAsssigned.name: notebookState.workoutsAssigned,
      });

      emit(
        notebookState.copyWith(
          workoutsAssigned: notebookState.workoutsAssigned,
        ),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookWorkoutsPlanEdited(
    NotebookWorkoutsPlanEdited event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      final workouts = notebookState.workoutsAssigned[event.date.toString()];
      final int idx = workouts!.indexWhere((w) => w.uuid == event.workout.uuid);

      workouts.removeAt(idx);
      workouts.insert(idx, event.workout);

      notebookState.workoutsAssigned[event.date.toString()] = workouts;

      await _repository.write(DataBoxKeys.other, {
        AppOtherKeys.dateWorkoutsAsssigned.name: notebookState.workoutsAssigned,
      });

      emit(
        notebookState.copyWith(
          workoutsAssigned: notebookState.workoutsAssigned,
        ),
      );
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }
}

String _getUuid() {
  return Uuid().v4();
}
