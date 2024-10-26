import 'package:flutter/material.dart';
import 'package:fit_track/WorkoutPage.dart';

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
              onPressed: () {},
              child: Text('Progress'),
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
