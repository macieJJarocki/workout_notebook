import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/presentation/home/bloc/home_bloc.dart';
import 'package:workout_notebook/presentation/home/widgets/home_view.dart';
import 'package:workout_notebook/utils/custom_bloc_observer.dart';

/*
TODO in the app:
  - add hive TypeAdapters(ExcersiseAdapter, TrainingAdapter)
  - implement Result for error handling
  - unit/widget/integrations tests

 */

void main() async {
  Bloc.observer = AppBlocsObserver();
  // init local db
  WidgetsFlutterBinding.ensureInitialized();
  final localPath = await getApplicationDocumentsDirectory();
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
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => LocalDbService(Hive),
          ),
          RepositoryProvider(
            create: (context) =>
                LocalDbRepository(context.read<LocalDbService>()),
          ),
        ],
        child: BlocProvider(
          create: (context) =>
              HomeBloc(
                repository: context.read<LocalDbRepository>(),
              )..add(
                HomeDataRequested(),
              ),
          child: const HomeView(),
        ),
      ),
    );
  }
}
