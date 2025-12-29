import 'package:hive_ce/hive.dart';
import 'package:workout_notebook/utils/const.dart';
import 'package:workout_notebook/utils/enums/enum_models.dart';
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
  Future<List<Map<String, dynamic>>> read(EnumModels key) async {
    try {
      final box = await init(boxName);
      final List<dynamic> boxContent = box.get(key.name, defaultValue: []);
      final result = boxContent
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // TODO return List<TypeAdapter> instead List<Map<String, dynamic>>
  Future<void> write(EnumModels key, List<Map<String, dynamic>> list) async {
    try {
      final box = await init(boxName);
      await box.put(key.name, list);
    } catch (e) {
      throw DbException("Can't put data into the local db.");
    }
  }
}
