import 'package:hive_ce/hive.dart';
import 'package:workout_notebook/utils/const.dart';
import 'package:workout_notebook/utils/enums.dart';
import 'package:workout_notebook/utils/exceptions.dart';

class LocalDbService {
  final HiveInterface _hive;

  LocalDbService(this._hive);
  Future<Box> init(String boxName) async {
    try {
      final box = await _hive.openBox(boxName);
      return box;
    } catch (e) {
      throw DbException("Can't connect to the local db.");
    }
  }

  // TODO should return List<TypeAdapter> instead List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> read(HiveBoxKey key) async {
    try {
      final box = await init(boxName);
      final dataOrNull = box.get(
        key.name,
        defaultValue: <Map<String, dynamic>>[],
      );
      // TODO After first data pulling box.get return null so method throw error
      // if (dataOrNull == null) {
      //   throw DbException("Can't read from the local db.");
      // }
      return dataOrNull;
    } catch (e) {
      rethrow;
    }
  }

  // TODO return List<TypeAdapter> instead List<Map<String, dynamic>>
  Future<void> write(HiveBoxKey key, List<Map<String, dynamic>> list) async {
    try {
      final box = await init(boxName);
      await box.put(key.name, list);
    } catch (e) {
      throw DbException("Can't put data into the local db.");
    }
  }
}
