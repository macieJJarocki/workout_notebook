import 'package:flutter/material.dart';
import 'package:workout_notebook/presentation/home/widgets/home_view_intro.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Center(
          child: Text('Home ??'),
        ),
      ),
      // TODO homeBloc.state ? HomeViewPlan : HomeViewIntro
      body: HomeViewIntro(),
    );
  }
}
