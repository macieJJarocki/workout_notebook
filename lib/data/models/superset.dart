import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';

class Superset extends Model {
  final List<Exercise> exercises;

  Superset(
    String? comment, {
    required super.uuid,
    required super.name,
    required this.exercises,
  }) : super(comment: comment);

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'comment': comment,
    };
  }

  @override
  Superset copyWith({
    String? uuid,
    String? comment,
    String? name,
    List<Exercise>? exercises,
  }) {
    return Superset(
      comment,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  String toString() {
    return 'Superset: (name: $name, exercises: $exercises)';
  }
}
