import 'package:flutter/material.dart';

class HomeViewIntro extends StatelessWidget {
  const HomeViewIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // TODO Create getters for width and height of the screen
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.red.shade200,
          border: .all(
            color: Colors.black,
          ),
          boxShadow: kElevationToShadow[24],
          borderRadius: .all(
            .circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Add your first workout plan here.',
              style: TextStyle(
                fontSize: 48,
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                'Create plan',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
