import 'package:workout_notebook/data/models/model.dart';

class Exercise extends Model {
  final int id;
  final bool isCompleted;
  final String name;
  final double weight;
  final int repetitions;
  final int sets;

  Exercise({
    required this.id,
    required this.isCompleted,
    required this.name,
    required this.weight,
    required this.repetitions,
    required this.sets,
  }) : super(id);

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
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
      'id': id,
      'isCompleted': isCompleted,
      'name': name,
      'weight': weight,
      'repetitions': repetitions,
      'sets': sets,
    };
  }

  Exercise copyWith({
    int? id,
    bool? isCompleted,
    String? name,
    double? weight,
    int? repetitions,
    int? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
      sets: sets ?? this.sets,
    );
  }
}
