part of 'workout_bloc.dart';

sealed class WorkoutState {
  @override
  String toString() {
    return '$runtimeType';
  }
}

final class WorkoutStateLoading extends WorkoutState {}

final class WorkoutStateSuccess extends WorkoutState {
  final List<Workout> workouts;
  final List<Exercise> exercises;
  final List<Exercise> unsavedExercises;

  WorkoutStateSuccess({
    required this.workouts,
    required this.exercises,
    required this.unsavedExercises,
  });
}

final class WorkoutStateFailure extends WorkoutState {
  final String message;

  WorkoutStateFailure({required this.message});
}
