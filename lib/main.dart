import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:workout_notebook/presentation/home/widgets/home_view.dart';

/*
TODO in the app:
  - add hive TypeAdapters(ExcersiseAdapter, TrainingAdapter)
  - implement Result for error handling
  - unit/widget/integrations tests

 */

void main() async {
  // init local db
  WidgetsFlutterBinding.ensureInitialized();
  final localPath = await path.getApplicationDocumentsDirectory();
  Hive.init(localPath.path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomeView(),
    );
  }
}
