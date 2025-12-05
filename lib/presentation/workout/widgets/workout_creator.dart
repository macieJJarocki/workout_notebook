import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_notebook/presentation/workout/bloc/workout_bloc.dart';
import 'package:workout_notebook/utils/enums/router_names.dart';

class WorkoutCreator extends StatelessWidget {
  const WorkoutCreator({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutBloc workoutBloc = context.read<WorkoutBloc>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Creator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.goNamed(RouterNames.intro.name),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Center(
        child: Container(
          // TODO Create getters for width and height of the screen or use Sizer
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: .spaceEvenly,
            children: [
              Text(workoutBloc.runtimeType.toString()),
              Text('Add your first workout plan here.'),
              OutlinedButton(
                onPressed: () {},
                child: Text('Create plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
