import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/data/models/workout.dart';
import 'package:workout_notebook/presentation/workout/create_workout_screen.dart';
import 'package:workout_notebook/presentation/notebook/notebook_home_screeen.dart';
import 'package:workout_notebook/presentation/notebook/notebook_view.dart';
import 'package:workout_notebook/presentation/workout/edit_workout_screen.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class AppRouter {
  RouterConfig<RouteMatchList> get router => _router;
  final _router = GoRouter(
    initialLocation: '/intro',
    // initialLocation: '/creator',
    routes: [
      GoRoute(
        path: '/intro',
        name: RouterNames.intro.name,
        builder: (context, state) => NotebookHomeScreen(),
      ),
      GoRoute(
        path: '/creator',
        name: RouterNames.creator.name,
        builder: (context, state) => state.extra is List
            ? EditWorkoutScreen(
                workout: (state.extra as List)[0],
                date: (state.extra as List)[1],
              )
            : CreateWorkoutScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => WorkoutView(),
      ),
    ],
    errorBuilder: (context, state) {
      // TODO add error builder
      return Scaffold();
    },
  );
}
