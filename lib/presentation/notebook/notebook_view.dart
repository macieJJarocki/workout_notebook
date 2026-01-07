import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/presentation/notebook/bloc/notebook_bloc.dart';
import 'package:workout_notebook/utils/app_router.dart';
import 'package:workout_notebook/utils/enums/hive_enums.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LocalDBService(Hive),
        ),
        RepositoryProvider(
          create: (context) => LocalDBRepository(
            context.read<LocalDBService>(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            NotebookBloc(
              repository: context.read<LocalDBRepository>(),
            )..add(
              NotebookDataRequested(
                boxes: DataBoxKeys.values,
              ),
            ),
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
