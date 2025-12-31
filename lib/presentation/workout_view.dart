import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/utils/app_router.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
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
        create: (context) => WorkoutBloc(
          repository: context.read<LocalDbRepository>(),
        )..add(WorkoutDataRequested()),
        child: MaterialApp.router(
          routerConfig: AppRouter().router,
          title: 'Workout Notebook',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.blueGrey.shade100,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey.shade100,
            ),
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
