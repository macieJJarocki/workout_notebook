import 'package:workout_notebook/data/models/exercise.dart';

class FakeData {
  FakeData._();
  static Map<String, dynamic> getExerciseAsMap() {
    return {
      'id': 1,
      'name': 'hip thrust',
      'weight': 20.0,
      'repetitions': 10,
      'sets': 3,
    };
  }

  static Exercise getExercise() {
    return Exercise(
      id: 1,
      name: 'deadlift',
      weight: 50,
      repetitions: 10,
      sets: 3,
    );
  }
}
