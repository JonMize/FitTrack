import 'package:flutter/material.dart';
import 'workout_page.dart';
import 'workout_list_page.dart'; // Import the new workout list page

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => WorkoutListPage()),
                );
              },
              child: Text('View Previous Workouts'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Nutrition'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
