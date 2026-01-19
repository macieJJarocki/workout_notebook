import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';

class Workout extends Model {
  Workout({
    required this.uuid,
    required this.name,
    required this.exercises,
    required this.isCompleted,
    required this.assignedDates,
    this.comment,
  }) : super(uuid, comment, name);

  final String uuid;
  final String? comment;
  final String name;
  final List<Exercise> exercises;
  final bool isCompleted;
  // TODO remove
  final List<DateTime> assignedDates;

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      uuid: map['uuid'],
      name: map['name'],
      exercises: map['exercises']
          .map<Exercise>((e) => Exercise.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      isCompleted: map['isCompleted'],
      // TODO can be null ?
      assignedDates: List<DateTime>.from(map['assignedDates']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'isCompleted': isCompleted,
      'dateTime': assignedDates,
    };
  }

  @override
  Workout copyWith({
    String? uuid,
    String? name,
    bool? isCompleted,
    List<Exercise>? exercises,
    List<DateTime>? assignedDates,
  }) {
    return Workout(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      exercises: exercises ?? this.exercises,
      assignedDates: assignedDates ?? this.assignedDates,
    );
  }

  @override
  String toString() {
    return 'Workout(name: $name, uuid: $uuid)';
  }
}
