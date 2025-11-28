import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_notebook/utils/const.dart';
import 'package:workout_notebook/utils/enums.dart';
import 'package:workout_notebook/utils/exceptions.dart';

class LocalDbService {
  final HiveInterface _hive;

  LocalDbService(this._hive);
  @visibleForTesting
  Future<Box> init(String boxName) async {
    try {
      return await _hive.openBox(boxName);
    } catch (e) {
      throw DbException("Can't connect to the local db.");
    }
  }
@visibleForTesting
  // TODO should return List<TypeAdapter>
  Future<List<dynamic>> read(HiveBoxKey key) async {
    // return part of the box state
    final box = await init(boxName);
    final List<dynamic>? dataOrNull = box.get(key.name);
    if (dataOrNull == null) {
      throw DbException("Can't read from the local db.");
    }
    return dataOrNull;
  }

  // TODO should take List<TypeAdapter>
  Future<void> write(HiveBoxKey key, List<dynamic> list) async {
    try {
    final box = await init(boxName);
      await box.put(key.name, list);
    } catch (e) {
      throw DbException("Can't put data into the local db.");
    }
  }
}
