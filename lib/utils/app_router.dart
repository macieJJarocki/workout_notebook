import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/active_workout_screen.dart';
import 'package:workout_notebook/presentation/workout/create_workout_screen.dart';
import 'package:workout_notebook/presentation/notebook/notebook_home_screeen.dart';
import 'package:workout_notebook/presentation/workout/edit_workout_screen.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class AppRouter {
  RouterConfig<RouteMatchList> get router => _router;
  final _router = GoRouter(
    initialLocation: '/workout',
    // initialLocation: '/workout/active',
    routes: [
      GoRoute(
        path: '/workout',
        name: RouterNames.workout.name,
        builder: (context, state) => NotebookHomeScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: RouterNames.create.name,
            builder: (context, state) => CreateWorkoutScreen(),
          ),
          GoRoute(
            path: 'edit',
            name: RouterNames.edit.name,
            builder: (context, state) => EditWorkoutScreen(
              workout: (state.extra as List)[0],
              date: (state.extra as List)[1],
            ),
          ),
          GoRoute(
            path: 'active',
            name: RouterNames.active.name,
            builder: (context, state) => ActiveWorkout(
              uuid: (state.extra as List)[0],
              date: (state.extra as List)[1],
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      // TODO add error builder
      return Scaffold();
    },
  );
}
