import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';

class LocalDBRepository {
  final LocalDBService _service;

  LocalDBRepository(LocalDBService service) : _service = service;

  Future<Map<String, dynamic>> read(DataBoxKeys key) async {
    try {
      final data = await _service.read(key);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> write(DataBoxKeys key, Map<String, dynamic> value) async {
    try {
      await _service.write(key, value);
    } catch (e) {
      rethrow;
    }
  }
}
