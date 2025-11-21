import 'package:flutter/material.dart';

class HomeViewPlan extends StatelessWidget {
  const HomeViewPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // TODO Create getters for width and height of the screen
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
            Text('Add your first workout plan here.'),
            OutlinedButton(
              onPressed: () {},
              child: Text('Create plan'),
            ),
          ],
        ),
      ),
    );
  }
}
