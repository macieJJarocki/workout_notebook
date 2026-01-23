import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_notebook/hive/hive_registrar.g.dart';
import 'package:workout_notebook/presentation/notebook/notebook_view.dart';
import 'package:workout_notebook/utils/custom_bloc_observer.dart';

/*
TODO in the app:
  - add hive TypeAdapters(ExcersiseAdapter, TrainingAdapter)
  - implement Result for error handling
  - unit/widget/integrations tests
  - icons licence 
  - create settings bloc

TODO fix:
  - unit tests

 */

void main() async {
  // App observer
  Bloc.observer = AppBlocsObserver();
  WidgetsFlutterBinding.ensureInitialized();
  // Hive init
  final localPath = await getApplicationDocumentsDirectory();
  Hive
    ..init(localPath.path)
    ..registerAdapters();

  runApp(const NotebookView());
}
