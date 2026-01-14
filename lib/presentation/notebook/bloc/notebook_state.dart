part of 'notebook_bloc.dart';

class NotebookState {}

final class NotebookInitial extends NotebookState {}

final class NotebookLoading extends NotebookState {}

final class NotebookSuccess extends NotebookState {
  final List<Workout> savedWorkouts;
  final String unsavedWorkoutName;
  final List<String> savedExercisesNames;
  final List<Exercise> unsavedExercises;
  final Map<String, List<Workout>> workoutsAssigned;

  NotebookSuccess({
    required this.savedWorkouts,
    required this.unsavedWorkoutName,
    required this.savedExercisesNames,
    required this.unsavedExercises,
    required this.workoutsAssigned,
  });

  NotebookSuccess copyWith({
    List<Workout>? savedWorkouts,
    String? unsavedWorkoutName,
    List<String>? savedExercisesNames,
    List<Exercise>? unsavedExercises,
    Map<String, List<Workout>>? workoutsAssigned,
  }) {
    return NotebookSuccess(
      savedWorkouts: savedWorkouts ?? this.savedWorkouts,
      unsavedWorkoutName: unsavedWorkoutName ?? this.unsavedWorkoutName,
      savedExercisesNames: savedExercisesNames ?? this.savedExercisesNames,
      unsavedExercises: unsavedExercises ?? this.unsavedExercises,
      workoutsAssigned: workoutsAssigned ?? this.workoutsAssigned,
    );
  }
}

final class NotebookFailure extends NotebookState {
  final String message;

  NotebookFailure(this.message);
}
