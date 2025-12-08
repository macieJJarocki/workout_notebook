import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_notebook/presentation/workout/workout_view.dart';
import 'package:workout_notebook/utils/custom_bloc_observer.dart';

/*
TODO in the app:
  - add hive TypeAdapters(ExcersiseAdapter, TrainingAdapter)
  - implement Result for error handling
  - unit/widget/integrations tests

TODO fix:
  - unit tests

 */

void main() async {
  Bloc.observer = AppBlocsObserver();
  // init local db
  WidgetsFlutterBinding.ensureInitialized();
  final localPath = await getApplicationDocumentsDirectory();
  Hive.init(localPath.path);

  runApp(const WorkoutView());
}
