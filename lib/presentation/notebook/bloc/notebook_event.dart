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

class NotebookSupersetCreated extends NotebookEvent {
  NotebookSupersetCreated({
    required this.supersetExercises,
    required this.supersetPosition,
    this.date,
    this.workout,
  });

  final List<Model> supersetExercises;
  final DateTime? date;
  // TODO change name supersetPosition
  final int supersetPosition;
  final Workout? workout;
}

class NotebookEntityEdited extends NotebookEvent {
  NotebookEntityEdited({
    required this.model,
    this.date,
    // TODO check if modelExercisesIdx is necessary, there is method to check index.
    this.modelExercisesIdx,
    this.supersetExerciseIdx,
  });

  final Model model;
  final DateTime? date;
  final int? modelExercisesIdx;
  final int? supersetExerciseIdx;
}

class NotebookEntityDeleted extends NotebookEvent {
  NotebookEntityDeleted({
    required this.model,
    this.date,
    this.workout,
    // TODO check if modelExercisesIdx is necessary, there is method to check index.
    this.modelExerciseIdx,
    this.supersetExerciseIdx,
  });

  final Model model;
  final Workout? workout;
  final DateTime? date;
  final int? modelExerciseIdx;
  final int? supersetExerciseIdx;
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
