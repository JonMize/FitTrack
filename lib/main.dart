import 'package:flutter/material.dart';
import 'workout_page.dart';
import 'view_previous_workouts.dart'; // Ensure this is imported
import 'share_workouts.dart'; // Import the new share workouts page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutPage()),
                );
              },
              child: Text('Workout'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewPreviousWorkoutsPage()),
                );
              },
              child: Text('View Previous Workouts'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShareWorkoutsPage()), // New button for sharing workouts
                );
              },
              child: Text('Share Workouts'),
            ),
          ],
        ),
      ),
    );
  }
}
