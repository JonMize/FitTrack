import 'package:flutter/material.dart';
import 'db_helper.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String date; // The date of the selected workout

  WorkoutDetailPage({required this.date});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _workoutDetails = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutDetails();
  }

  void _loadWorkoutDetails() async {
    final workoutDetails = await _dbHelper.getWorkoutDetails(widget.date);
    setState(() {
      _workoutDetails = workoutDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Workout on ${widget.date}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _workoutDetails.length,
                itemBuilder: (context, index) {
                  var detail = _workoutDetails[index];
                  return ListTile(
                    title: Text('Exercise: ${detail['exercise']}'),
                    subtitle: Text(
                        'Weight: ${detail['weight']}kg, Reps: ${detail['reps']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
