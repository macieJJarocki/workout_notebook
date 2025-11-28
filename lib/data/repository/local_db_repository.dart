import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/training.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/utils/enums.dart';

class LocalDbRepository {
  final LocalDbService service;

  LocalDbRepository(this.service);

  Future<List<Model>> read(HiveBoxKey boxName) async {
    final List<dynamic> rawData = await service.read(boxName);
    return rawData.map(
      (map) {
        switch (map.runtimeType) {
          case Workout _:
            return Workout.fromMap(map);
          case Exercise _:
            return Exercise.fromMap(map);
          default:
            throw Exception('Error from repo');
        }
      },
    ).toList();
  }

  Future<void> write(HiveBoxKey boxName, Model model) async {
    final data = [...await read(boxName), model]
        .map(
          (e) => e.toMap(),
        )
        .toList();

    service.write(boxName, data);
  }

  Future<void> update(HiveBoxKey boxName, Model model) async {
    final data = await read(boxName);

    final updatedData = data
        .map(
          (e) => e.id == model.id ? model.toMap() : e.toMap(),
        )
        .toList();

    service.write(boxName, updatedData);
  }

  Future<void> delete(HiveBoxKey boxName, Model model) async {
    final data = await read(boxName);

    data.removeWhere(
      (element) => element.id == model.id,
    );

    final updatedData = data
        .map(
          (element) => element.toMap(),
        )
        .toList();

    service.write(boxName, updatedData);
  }
}
