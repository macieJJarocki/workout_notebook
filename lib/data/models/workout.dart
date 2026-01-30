import 'package:workout_notebook/data/models/model.dart';

class Workout extends Model {
  Workout(
    String? comment, {
    required super.uuid,
    required super.name,
    required this.exercises,
    required this.isCompleted,
  }) : super(comment: comment);

  final List<Model> exercises;
  final bool isCompleted;

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      map['comment'],
      uuid: map['uuid'],
      name: map['name'],
      exercises: map['exercises'],
      isCompleted: map['isCompleted'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'isCompleted': isCompleted,
    };
  }

  @override
  Workout copyWith({
    String? uuid,
    String? name,
    List<Model>? exercises,
    bool? isCompleted,
    String? comment,
  }) {
    return Workout(
      comment ?? this.comment,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  String toString() {
    return 'Workout(name: $name, uuid: $uuid, isComplteted: $isCompleted)';
  }
}
