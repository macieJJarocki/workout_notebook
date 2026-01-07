part of 'notebook_bloc.dart';

class NotebookEvent {}

class NotebookDataRequested extends NotebookEvent {
  final List<DataBoxKeys> boxes;

  NotebookDataRequested({required this.boxes});
}

class NotebookWorkoutCreated extends NotebookEvent {
  final String name;

  NotebookWorkoutCreated({required this.name});
}

class NotebookWorkoutNameRequested extends NotebookEvent {
  final String name;

  NotebookWorkoutNameRequested(this.name);
}

class NotebookWorkoutDeleted extends NotebookEvent {
  final String uuid;

  NotebookWorkoutDeleted({required this.uuid});
}

class NotebookExerciseCreated extends NotebookEvent {
  final String name;
  final String weight;
  final String repetitions;
  final String sets;

  NotebookExerciseCreated({
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.sets,
  });
}

class NotebookExerciseEdited extends NotebookEvent {
  final Exercise exercise;
  NotebookExerciseEdited({required this.exercise});
}

class NotebookExerciseDeleted extends NotebookEvent {
  final Workout? workout;
  final String uuid;
  NotebookExerciseDeleted({this.workout, required this.uuid});
}
