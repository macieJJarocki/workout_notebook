import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/widgets/workout_creator.dart';
import 'package:workout_notebook/presentation/workout/widgets/workout_intro.dart';
import 'package:workout_notebook/presentation/workout/widgets/workout_view.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class AppRouter {
  RouterConfig<RouteMatchList> get router => _router;
  final _router = GoRouter(
    // initialLocation: '/intro',
    initialLocation: '/creator',
    routes: [
      GoRoute(
        path: '/intro',
        name: RouterNames.intro.name,
        builder: (context, state) => WorkoutIntro(),
      ),
      GoRoute(
        path: '/creator',
        name: RouterNames.creator.name,
        builder: (context, state) => WorkoutCreator(),
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
