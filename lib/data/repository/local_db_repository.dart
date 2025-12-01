import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/utils/enums.dart';

class LocalDbRepository {
  final LocalDbService service;

  LocalDbRepository(this.service);

  Future<List<Model>> read(HiveBoxKey key) async {
    try {
      final List<Map<String, dynamic>> rawData = await service.read(key);
      final data = rawData.map(
        (map) {
          switch (key) {
            case HiveBoxKey.workouts:
              return Workout.fromMap(map);
            case HiveBoxKey.exercises:
              return Exercise.fromMap(map);
          }
        },
      ).toList();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> write(HiveBoxKey key, Model model) async {
    try {
      final data = [...await read(key), model]
          .map(
            (e) => e.toMap(),
          )
          .toList();

      await service.write(key, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(HiveBoxKey key, Model model) async {
    try {
      final data = await read(key);

      final updatedData = data
          .map(
            (e) => e.id == model.id ? model.toMap() : e.toMap(),
          )
          .toList();
      await service.write(key, updatedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(HiveBoxKey key, Model model) async {
    try {
      final data = await read(key);

      data.removeWhere(
        (element) => element.id == model.id,
      );

      final updatedData = data
          .map(
            (element) => element.toMap(),
          )
          .toList();

      await service.write(key, updatedData);
    } catch (e) {
      rethrow;
    }
  }
}
