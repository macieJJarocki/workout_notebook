import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';

class Workout extends Model {
  final int id;
  final bool isCompleted;
  final List<Exercise> exercises;
  final DateTime? dateTime;

  Workout({
    required this.id,
    required this.isCompleted,
    required this.exercises,
     this.dateTime,
  }) : super(id, isCompleted);
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      isCompleted: map['isCompleted'],
      exercises: map['exercises'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'exercises': exercises, 'dateTime': dateTime};
  }
  @override
  Workout copyWith({
    int? id,
    bool? isCompleted,
    List<Exercise>? exercises,
    DateTime? dateTime,
  }) {
    return Workout(
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      exercises: exercises ?? this.exercises,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
