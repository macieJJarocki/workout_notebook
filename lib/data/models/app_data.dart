import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';

class AppData extends Model {
  final int id;
  final List<Exercise> unsavedExercises;

  AppData({
    required this.id,
    required this.unsavedExercises,
  }) : super(id);

  factory AppData.fromMap(Map<String, dynamic> map) {
    return AppData(
      id: map['id'],
      unsavedExercises: map['unsavedExercises'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unsavedExercises': unsavedExercises,
    };
  }

  @override
  AppData copyWith({List<Exercise>? unsavedExercises}) {
    return AppData(
      id: id,
      unsavedExercises: unsavedExercises ?? this.unsavedExercises,
    );
  }
}
