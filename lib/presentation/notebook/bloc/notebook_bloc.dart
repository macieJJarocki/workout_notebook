import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/superset.dart';
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
    on<NotebookWorkoutNameRequested>(_onNotebookWorkoutNameRequested);
    on<NotebookPlanExerciseAdded>(_onNotebookPlanExerciseAdded);
    on<NotebookEntityCreated>(_onNotebookEntityCreated);
    on<NotebookEntityEdited>(_onNotebookEntityEdited);
    on<NotebookEntityDeleted>(_onNotebookEntityDeleted);
    on<NotebookSupersetCreated>(_onNotebookSupersetCreated);
  }
  // TODO refactor NotebookBloc to unify method for DateBoxKeys !!!!!!!!!!!!

  void _onNotebookDataRequested(
    NotebookDataRequested event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      emit(NotebookLoading());
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
          unsavedExercises: List<Model>.from(
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

  void _onNotebookEntityCreated(
    NotebookEntityCreated event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      NotebookSuccess notebookState = state as NotebookSuccess;
      late final Model model;
      late final List<Model> list;
      late final Map<String, dynamic> payload;
      emit(NotebookLoading());
      switch (event.key) {
        case DataBoxKeys.exercises:
          // Exercises
          model = Exercise(
            null,
            uuid: _getUuid(),
            name: event.name,
            isCompleted: false,
            weight: event.weight != null
                ? double.tryParse(event.weight as String)
                : null,
            repetitions: event.repetitions != null
                ? int.tryParse(event.repetitions as String)
                : null,
            sets: event.sets != null
                ? int.tryParse(event.sets as String)
                : null,
          );
          notebookState.unsavedExercises.add(model as Exercise);
          list = notebookState.unsavedExercises;
          payload = {
            AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
            AppWorkoutKeys.unsaved.name: list,
          };
          notebookState.copyWith(unsavedExercises: []);
        case DataBoxKeys.workouts:
          // Workouts
          model = Workout(
            null,
            uuid: _getUuid(),
            name: event.name,
            exercises: notebookState.unsavedExercises,
            isCompleted: false,
          );
          notebookState.savedWorkouts.add(model as Workout);
          list = notebookState.savedWorkouts;
          payload = {
            AppWorkoutKeys.saved.name: list as List<Workout>,
            AppWorkoutKeys.unsaved.name: '',
          };
          final savedExercisesNames = list.fold(
            <String>[],
            (previousValue, element) {
              element.exercises.map((e) {
                if (!previousValue.contains(e.name)) {
                  previousValue.add(e.name);
                }
              }).toList();
              return previousValue;
            },
          );

          notebookState = notebookState.copyWith(
            savedWorkouts: list,
            unsavedWorkoutName: '',
            unsavedExercises: [],
            savedExercisesNames: savedExercisesNames,
          );

        case DataBoxKeys.other:
          final String date = event.date.toString();
          final Map<String, List<Workout>> workoutsAssigned =
              notebookState.workoutsAssigned;
          final workout = event.workout!.copyWith(
            exercises: [...event.workout!.exercises],
          );

          if (!workoutsAssigned.containsKey(date)) {
            workoutsAssigned[date] = [workout];
          } else {
            switch (workoutsAssigned[date]!.any(
              (element) => element.name == workout.name,
            )) {
              case false:
                workoutsAssigned[date]!.add(workout);
              case true:
            }
          }
          payload = {
            AppOtherKeys.dateWorkoutsAsssigned.name: workoutsAssigned,
          };
          notebookState.copyWith(workoutsAssigned: workoutsAssigned);
      }
      await _repository.write(event.key, payload);
      if (event.key == DataBoxKeys.workouts) {
        // if (event.key == DataBoxKeys.workouts && event.date != null) {
        // Saved exercises names
        // [&& event.date != null] avoid unnecessary db call during the "WorkoutAssigned'' case
        await _repository.write(DataBoxKeys.exercises, {
          AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
          AppWorkoutKeys.unsaved.name: notebookState.unsavedExercises,
        });
      }
      emit(notebookState);
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookSupersetCreated(
    NotebookSupersetCreated event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      NotebookSuccess notebookState = state as NotebookSuccess;
      late final DataBoxKeys key;
      late final Map<String, dynamic> payload;
      late final int idx;
      emit(NotebookLoading());
      final superset = Superset(
        null,
        uuid: _getUuid(),
        name:
            'Superset #${((event.workout is Workout ? event.workout!.exercises : notebookState.unsavedExercises).whereType<List>().length + 1).toString()}',
        exercises: event.supersetExercises.fold(
          <Exercise>[],
          (prev, element) => element is Superset
              ? [...prev, ...element.exercises]
              : [...prev, element as Exercise],
        ),
      );
      final List<Model> list = List<Model>.from(
        (event.workout is Workout
                ? event.workout!.exercises
                : notebookState.unsavedExercises)
            .map((e) {
              return !event.supersetExercises.contains(e) ? e : null;
            })
            .whereType<Exercise>(),
      );
      if (event.workout is Workout) {
        // EditWorkoutScreen
        final dateAsString = event.date!.toString();
        key = DataBoxKeys.other;
        payload = {
          AppOtherKeys.dateWorkoutsAsssigned.name:
              notebookState.workoutsAssigned,
        };
        idx = _getElementPosition(
          notebookState.workoutsAssigned[dateAsString]!,
          event.workout!,
        );
        final updated = notebookState.workoutsAssigned;
        updated[dateAsString]![idx] = updated[dateAsString]![idx].copyWith(
          exercises: list,
        );
        notebookState = notebookState.copyWith(workoutsAssigned: updated);
      } else {
        // CreateWorkoutScreen
        key = DataBoxKeys.exercises;
        payload = {
          AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
          AppWorkoutKeys.unsaved.name: notebookState.unsavedExercises,
        };
        notebookState = notebookState.copyWith(unsavedExercises: list);
      }

      // TODO In supersetMode error occure when [Exercise] ia added before [Superset] into supersetExercises
      // In future replece .add() with vvvv
      // exercises.insert(event.supersetPosition, superset);
      list.add(superset);
      await _repository.write(key, payload);
      emit(notebookState);
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookEntityEdited(
    NotebookEntityEdited event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      late final List<Model> list;
      late final DataBoxKeys key;
      late final Map<String, dynamic> payload;
      late final int idx;
      emit(NotebookLoading());
      switch (event.model.runtimeType) {
        case == Workout:
          if (event.date == null) {
            // CreateWorkoutScreeen
            list = notebookState.savedWorkouts;
            key = DataBoxKeys.workouts;
            idx = _getElementPosition(list, event.model);
            payload = {
              AppWorkoutKeys.saved.name: list,
              AppWorkoutKeys.unsaved.name: notebookState.unsavedWorkoutName,
            };
            notebookState.copyWith(savedWorkouts: list as List<Workout>);
          } else {
            // EditWorkoutScreeen
            final String dateAsString = event.date!.toString();
            key = DataBoxKeys.other;
            list = notebookState.workoutsAssigned[dateAsString]!;
            final updated = notebookState.workoutsAssigned;

            if (event.supersetExerciseIdx is int) {
              idx = event.modelExercisesIdx!;
            } else {
              idx = _getElementPosition(list, event.model);
            }
            payload = {
              AppOtherKeys.dateWorkoutsAsssigned.name:
                  notebookState.workoutsAssigned,
            };
            updated[dateAsString] = list as List<Workout>;
            notebookState.copyWith(workoutsAssigned: updated);
          }
        default:
          // Exercise and Superset
          if (event.date == null) {
            // CreateWorkoutScreeen
            key = DataBoxKeys.exercises;
            payload = {
              AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
              AppWorkoutKeys.unsaved.name: notebookState.unsavedExercises,
            };
            if (event.supersetExerciseIdx is int) {
              // Edit [Superset] exercises
              final superset =
                  (notebookState.unsavedExercises[event.modelExercisesIdx!]
                      as Superset);
              list = superset.exercises;
              idx = event.supersetExerciseIdx!;
              superset.copyWith(exercises: list as List<Exercise>);
              final updatedUnsavedExercises = notebookState.unsavedExercises;
              updatedUnsavedExercises[event.modelExercisesIdx!] = superset;
              notebookState.copyWith(unsavedExercises: updatedUnsavedExercises);
            } else {
              // Edit [Exercise] and [Superset]
              list = notebookState.unsavedExercises;
              idx = event.modelExercisesIdx!;
              notebookState.copyWith(unsavedExercises: list);
            }
          }
      }

      list.removeAt(idx);
      list.insert(idx, event.model);
      await _repository.write(key, payload);
      emit(notebookState);
    } catch (e) {
      emit(NotebookFailure(e.toString()));
    }
  }

  void _onNotebookEntityDeleted(
    NotebookEntityDeleted event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;
      late final List<Model> list;
      late final DataBoxKeys key;
      late final Map<String, dynamic> payload;
      late final int idx;
      emit(NotebookLoading());
      switch (event.model.runtimeType) {
        case == Workout:
          if (event.date == null) {
            // Workouts
            list = notebookState.savedWorkouts;
            key = DataBoxKeys.workouts;
            idx = _getElementPosition(list, event.model);
            payload = {
              AppWorkoutKeys.saved.name: list,
              AppWorkoutKeys.unsaved.name: notebookState.unsavedWorkoutName,
            };
            notebookState.copyWith(savedWorkouts: list as List<Workout>);
          } else {
            // AssignedWorkouts
            final String dateAsString = event.date!.toString();
            list = notebookState.workoutsAssigned[dateAsString]!;
            key = DataBoxKeys.other;
            idx = _getElementPosition(list, event.model);

            payload = {
              AppOtherKeys.dateWorkoutsAsssigned.name:
                  notebookState.workoutsAssigned,
            };
          }
        default:
          // Exercise and Superset
          if (event.date == null) {
            // CreateWorkoutScreeen
            key = DataBoxKeys.exercises;
            if (event.supersetExerciseIdx is int) {
              list = (event.model as Superset).exercises;
              idx = event.supersetExerciseIdx!;
              payload = {
                AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
                AppWorkoutKeys.unsaved.name: list,
              };
            } else {
              list = notebookState.unsavedExercises;
              idx = _getElementPosition(list, event.model);
              payload = {
                AppWorkoutKeys.saved.name: notebookState.savedExercisesNames,
                AppWorkoutKeys.unsaved.name: list,
              };
            }
            notebookState.copyWith(unsavedExercises: list);
          } else {
            // EditWorkoutScreeen
            final String dateAsString = event.date!.toString();
            key = DataBoxKeys.other;
            final workoutsList = notebookState.workoutsAssigned[dateAsString];
            final workoutIdx = _getElementPosition(
              workoutsList!,
              event.workout!,
            );
            if (event.supersetExerciseIdx is int) {
              // Remove [Exercise] from [Superset] exercises to assigned [WorkoutAssigned]
              list = (event.model as Superset).exercises;
              idx = event.supersetExerciseIdx!;
            } else {
              // Remove [Exercise] or [Superset] from [WorkoutAssigned] exeercises
              list = workoutsList[workoutIdx].exercises;
              idx = event.modelExerciseIdx!;
            }
            payload = {
              AppOtherKeys.dateWorkoutsAsssigned.name:
                  notebookState.workoutsAssigned,
            };
            workoutsList[workoutIdx].copyWith(exercises: list);
          }
      }
      list.removeAt(idx);
      if (event.date != null && event.model is Workout) {
        // Remove key[date] if list of the assigned workouts is empty
        list.isEmpty
            ? notebookState.workoutsAssigned.remove(event.date.toString())
            : null;
      }
      await _repository.write(key, payload);
      emit(notebookState);
    } catch (e) {
      emit(NotebookFailure(e.toString()));
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

  void _onNotebookPlanExerciseAdded(
    NotebookPlanExerciseAdded event,
    Emitter<NotebookState> emit,
  ) async {
    try {
      final notebookState = state as NotebookSuccess;

      final newExercise = Exercise(
        null,
        uuid: _getUuid(),
        name: event.name,
        weight: double.tryParse(event.weight),
        repetitions: int.tryParse(event.repetitions),
        sets: int.tryParse(event.sets),
        isCompleted: false,
      );

      final editedWorkouts = notebookState
          .workoutsAssigned[event.date.toString()]!
          .map(
            (e) {
              if (e.uuid == event.workout.uuid) {
                return event.workout.copyWith(
                  exercises: [...event.workout.exercises, newExercise],
                );
              }
              return e;
            },
          )
          .toList();

      notebookState.workoutsAssigned[event.date.toString()] = editedWorkouts;

      _repository.write(DataBoxKeys.other, {
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

int _getElementPosition(List<Model> list, Model model) {
  final int idx = list.indexWhere(
    (element) => element.uuid == model.uuid,
  );
  return idx;
}
