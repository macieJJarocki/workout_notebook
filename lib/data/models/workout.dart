import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';

class Workout extends Model {
  final int id;
  final bool isCompleted;
  final List<Exercise> exercises;
  final DateTime? dateTime;
  // TODO add name 

  Workout({
    required this.id,
    required this.isCompleted,
    required this.exercises,
    this.dateTime,
  }) : super(id);

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      isCompleted: map['isCompleted'],
      exercises: map['exercises']
          .map<Exercise>((e) => Exercise.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      dateTime: map['dateTime'] == null
          ? null
          : DateTime.tryParse(map['dateTime']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'exercises': exercises
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      'dateTime': dateTime,
    };
  }

  @override
  Workout copyWith({
    bool? isCompleted,
    List<Exercise>? exercises,
    DateTime? dateTime,
  }) {
    return Workout(
      id: id,
      isCompleted: isCompleted ?? this.isCompleted,
      exercises: exercises ?? this.exercises,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
