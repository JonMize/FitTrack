import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'workout_detail_page.dart';

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    List<Map<String, dynamic>> workouts = await _dbHelper.getWorkouts();
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
          return ListTile(
            title: Text(_workouts[index]['exercise']),
            subtitle: Text(
                'Weight: ${_workouts[index]['weight']} kg, Reps: ${_workouts[index]['reps']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorkoutDetailPage(workoutId: _workouts[index]['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
