part of 'workout_bloc.dart';

sealed class WorkoutState {
  @override
  String toString() {
    return '$runtimeType';
  }
}

final class WorkoutStateLoading extends WorkoutState {}

final class WorkoutStateSuccess extends WorkoutState {
  final List<Model> workouts;
  final List<Model> exercises;

  WorkoutStateSuccess({
    this.workouts = const [],
    this.exercises = const [],
  });
}

final class WorkoutStateFailure extends WorkoutState {
  final String message;

  WorkoutStateFailure({required this.message});
}
