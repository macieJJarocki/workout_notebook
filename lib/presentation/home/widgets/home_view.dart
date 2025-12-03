import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_notebook/presentation/home/bloc/home_bloc.dart';
import 'package:workout_notebook/presentation/home/widgets/home_view_intro.dart';
import 'package:workout_notebook/presentation/home/widgets/home_view_plan.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Center(
          child: Text('${context.watch<HomeBloc>().state.runtimeType}'),
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeStateSuccess) {
            return state.workouts.isEmpty ? HomeViewIntro() : HomeViewPlan();
          }
          return Center(child: CircularProgressIndicator.adaptive());
        },
        listener: (context, state) {
          if (state is HomeStateFailure) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                content: Text(state.message),
              ),
            );
          }
        },
      ),
    );
  }
}
