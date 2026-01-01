import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';

class Workout extends Model {
  final int id;
  final String name;
  final List<Exercise> exercises;
  final bool isCompleted;
  final DateTime? dateTime;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
    required this.isCompleted,
    this.dateTime,
  }) : super(id);

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      exercises: map['exercises']
          .map<Exercise>((e) => Exercise.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      isCompleted: map['isCompleted'],
      dateTime: map['dateTime'] == null
          ? null
          : DateTime.tryParse(map['dateTime']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      'isCompleted': isCompleted,
      'dateTime': dateTime,
    };
  }

  @override
  Workout copyWith({
    String? name,
    bool? isCompleted,
    List<Exercise>? exercises,
    DateTime? dateTime,
  }) {
    return Workout(
      id: id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      exercises: exercises ?? this.exercises,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
