part of 'workout_bloc.dart';

sealed class WorkoutEvent {
  @override
  String toString() {
    return '$runtimeType';
  }
}

class WorkoutDataRequested extends WorkoutEvent {}

class WorkoutExerciseCreated extends WorkoutEvent {
  final String name;
  final String weight;
  final String repetitions;
  final String sets;

  WorkoutExerciseCreated({
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.sets,
  });
}
