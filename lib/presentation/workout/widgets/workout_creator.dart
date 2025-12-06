import 'dart:ui';

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
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: .circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: .circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: .circular(10),
                          ),
                          child: ListView(
                            children: [
                              Text('data'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Add exercise'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Add superset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade200,
                          borderRadius: .circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: .spaceEvenly,
                          children: [
                            Text(
                              'Add  exercise',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextField(
                              decoration: InputDecoration(
                                label: Text('name'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                label: Text('weight'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                label: Text('repetitions'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                label: Text('sets'),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
