import 'package:workout_notebook/data/models/model.dart';

class Exercise extends Model {
  final String uuid;
  final String? comment;
  final bool isCompleted;
  final String name;
  final double weight;
  final int repetitions;
  final int sets;

  Exercise({
    required this.uuid,
    required this.isCompleted,
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.sets,
    this.comment,
  }) : super(uuid, comment);

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
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
    bool? isCompleted,
    String? name,
    double? weight,
    int? repetitions,
    int? sets,
  }) {
    return Exercise(
      uuid: uuid,
      isCompleted: isCompleted ?? this.isCompleted,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
      sets: sets ?? this.sets,
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
