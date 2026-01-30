import 'package:workout_notebook/data/models/model.dart';

class Exercise extends Model {
  Exercise(
    String? comment, {
    required super.uuid,
    required super.name,
    required this.isCompleted,
    this.weight,
    this.repetitions,
    this.sets,
  });

  final bool isCompleted;
  final double? weight;
  final int? repetitions;
  final int? sets;

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      map['comment'],
      uuid: map['uuid'],
      isCompleted: map['isCompleted'],
      name: map['name'],
      weight: map['weight'],
      repetitions: map['repetitions'],
      sets: map['sets'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'isCompleted': isCompleted,
      'name': name,
      'weight': weight,
      'repetitions': repetitions,
      'sets': sets,
    };
  }

  @override
  Exercise copyWith({
    String? name,
    double? weight,
    int? repetitions,
    int? sets,
    bool? isCompleted,
    String? comment,
  }) {
    return Exercise(
      comment ?? this.comment,
      uuid: uuid,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
      sets: sets ?? this.sets,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Exercise: ${toMap().toString()}';
  }
}
