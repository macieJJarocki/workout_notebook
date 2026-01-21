part of 'notebook_bloc.dart';

class NotebookEvent {}

class NotebookDataRequested extends NotebookEvent {
  final List<DataBoxKeys> boxes;

  NotebookDataRequested({required this.boxes});
}

class NotebookEntityCreated extends NotebookEvent {
  NotebookEntityCreated({
    this.weight,
    this.repetitions,
    this.sets,
    this.workout,
    this.date,
    required this.key,
    required this.name,
  });

  final DataBoxKeys key;
  final String name;
  final String? weight;
  final String? repetitions;
  final String? sets;
  final Workout? workout;
  final DateTime? date;
}

class NotebookEntityEdited extends NotebookEvent {
  NotebookEntityEdited({required this.model, this.exerciseIdx, this.date});

  final Model model;
  final DateTime? date;
  final int? exerciseIdx;
}

class NotebookEntityDeleted extends NotebookEvent {
  NotebookEntityDeleted({required this.model, this.date});

  final Model model;
  final DateTime? date;
}

class NotebookWorkoutNameRequested extends NotebookEvent {
  final String name;

  NotebookWorkoutNameRequested(this.name);
}

class NotebookPlanExerciseAdded extends NotebookEvent {
  NotebookPlanExerciseAdded({
    required this.date,
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.sets,
    required this.workout,
  });
  final DateTime date;
  final Workout workout;
  final String name;
  final String weight;
  final String repetitions;
  final String sets;
}
