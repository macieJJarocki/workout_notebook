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

class WorkoutExerciseEdited extends WorkoutEvent {
  final int id;
  final Map<String, dynamic> modyfiedExerciseData;

  WorkoutExerciseEdited({
    required this.id,
    required this.modyfiedExerciseData,
  });
}

class WorkoutExerciseDeleted extends WorkoutEvent {
  final Exercise exercise;

  WorkoutExerciseDeleted({required this.exercise});
}

class WorkoutCreated extends WorkoutEvent {
  final List<Exercise> exercises;

  WorkoutCreated({required this.exercises});
}
