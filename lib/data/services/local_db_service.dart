import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';
import 'package:workout_notebook/utils/exceptions.dart';

class LocalDBService {
  final HiveInterface _hive;
  late Box _box;

  LocalDBService(HiveInterface hive) : _hive = hive;

  Future<void> _init() async {
    try {
      !_hive.isBoxOpen(Appdata.data.name)
          ? _box = await _hive.openBox(Appdata.data.name)
          : null;
    } catch (e) {
      throw DbException("Can't connect to the local db.");
    }
  }

  Future<Map<String, dynamic>> read(DataBoxKeys key) async {
    try {
      await _init();
      return Map<String, dynamic>.from(
        _box.get(key.name, defaultValue: _defaultValue[key.name]),
      );
    } catch (e) {
      throw DbException("Can't read data from the local db.");
    }
  }

  Future<void> write(DataBoxKeys key, dynamic value) async {
    try {
      await _init();
      await _box.put(key.name, value);
    } catch (e) {
      throw DbException("Can't put data into the local db.");
    }
  }

  final Map<String, dynamic> _defaultValue = {
    DataBoxKeys.workouts.name: {
      AppBoxKeys.saved.name: <Workout>[],
      AppBoxKeys.unsaved.name: '',
    },
    DataBoxKeys.exercises.name: {
      AppBoxKeys.saved.name: <String>[],
      AppBoxKeys.unsaved.name: <Exercise>[],
    },
    DataBoxKeys.other.name: {},
  };
}
