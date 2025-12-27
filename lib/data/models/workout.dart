import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';

class Workout extends Model {
  final int id;
  final List<Exercise> exercises;

  Workout({required this.id, required this.exercises}) : super(id);
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      exercises: map['exercises'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercises': exercises,
    };
  }

  Workout copyWith({int? id, List<Exercise>? exercises}) {
    return Workout(id: id ?? this.id, exercises: exercises ?? this.exercises);
  }
}
