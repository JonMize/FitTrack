import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'workout_detail_page.dart';

class ViewPreviousWorkoutsPage extends StatefulWidget {
  @override
  _ViewPreviousWorkoutsPageState createState() =>
      _ViewPreviousWorkoutsPageState();
}

class _ViewPreviousWorkoutsPageState extends State<ViewPreviousWorkoutsPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    final workouts = await _dbHelper.getWorkouts();
    setState(() {
      _workouts = workouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Workouts'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          String workoutDate = _workouts[index]['date'];
          return ListTile(
            title: Text('Workout on $workoutDate'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailPage(date: workoutDate),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
