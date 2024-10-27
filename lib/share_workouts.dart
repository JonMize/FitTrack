import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for clipboard functionality
import 'db_helper.dart';

class ShareWorkoutsPage extends StatefulWidget {
  @override
  _ShareWorkoutsPageState createState() => _ShareWorkoutsPageState();
}

class _ShareWorkoutsPageState extends State<ShareWorkoutsPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  // Load all workouts from the database
  void _loadWorkouts() async {
    final workouts = await _dbHelper.getWorkouts();
    setState(() {
      _workouts = workouts;
      print("Loaded workouts for sharing: $_workouts"); // Log for debugging
    });
  }

  // Copy workout details to clipboard
  void _copyToClipboard(String workoutDetails) {
    Clipboard.setData(ClipboardData(text: workoutDetails)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout copied to clipboard!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Workouts'),
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
            onTap: () async {
              // Retrieve the full workout details from the database
              final workoutDetails =
                  await _dbHelper.getWorkoutDetails(workoutDate);
              String detailsString = workoutDetails.map((set) {
                return "${set['exercise']}: ${set['weight']} kg, ${set['reps']} reps";
              }).join('\n');
              _copyToClipboard(detailsString);
            },
          );
        },
      ),
    );
  }
}
