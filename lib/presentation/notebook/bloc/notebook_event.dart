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

class NotebookWorkoutsPlanDateAssigned extends NotebookEvent {
  final Workout workout;
  final DateTime date;

  NotebookWorkoutsPlanDateAssigned({
    required this.workout,
    required this.date,
  });
}

class NotebookWorkoutNameRequested extends NotebookEvent {
  final String name;

  NotebookWorkoutNameRequested(this.name);
}

class NotebookWorkoutDeleted extends NotebookEvent {
  final String uuid;

  NotebookWorkoutDeleted({required this.uuid});
}

class NotebookWorkoutEdited extends NotebookEvent {
  final Workout workout;

  NotebookWorkoutEdited({required this.workout});
}

class NotebookExerciseCreated extends NotebookEvent {
  final String name;
  final String? weight;
  final String? repetitions;
  final String? sets;

  NotebookExerciseCreated({
    required this.name,
    this.weight,
    this.repetitions,
    this.sets,
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

class NotebookPlanWorkoutDeleted extends NotebookEvent {
  NotebookPlanWorkoutDeleted({required this.date, required this.workout});

  final DateTime date;
  final Workout workout;
}

class NotebookPlanWorkoutEdited extends NotebookEvent {
  NotebookPlanWorkoutEdited({required this.workout, required this.date});
  final DateTime date;
  final Workout workout;
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
