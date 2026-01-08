import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';

class Workout extends Model {
  final String uuid;
  final String? comment;
  final String name;
  final List<Exercise> exercises;
  final bool isCompleted;
  // TODO change name
  final List<DateTime> assignedDates;

  Workout({
    required this.uuid,
    required this.name,
    required this.exercises,
    required this.isCompleted,
    required this.assignedDates,
    this.comment,
  }) : super(uuid, comment);

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
    String? name,
    bool? isCompleted,
    List<Exercise>? exercises,
    List<DateTime>? assignedDates,
  }) {
    return Workout(
      uuid: uuid,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      exercises: exercises ?? this.exercises,
      assignedDates: assignedDates ?? this.assignedDates,
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
