import 'package:flutter/material.dart';
import 'db_helper.dart';

class WorkoutDetailPage extends StatefulWidget {
  final int workoutId;

  WorkoutDetailPage({required this.workoutId});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  final DBHelper _dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();

  String _exercise = '';
  int _weight = 0;
  int _reps = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkout();
  }

  void _loadWorkout() async {
    List<Map<String, dynamic>> workout = await _dbHelper.getWorkouts();
    var selectedWorkout =
        workout.firstWhere((w) => w['id'] == widget.workoutId);
    setState(() {
      _exercise = selectedWorkout['exercise'];
      _weight = selectedWorkout['weight'];
      _reps = selectedWorkout['reps'];
    });
  }

  void _updateWorkout() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _dbHelper.insertWorkout({
        'id': widget.workoutId,
        'exercise': _exercise,
        'weight': _weight,
        'reps': _reps,
      });
      Navigator.pop(context); // Go back to the workout list page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _exercise,
                decoration: InputDecoration(labelText: 'Exercise'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise';
                  }
                  return null;
                },
                onSaved: (value) {
                  _exercise = value!;
                },
              ),
              TextFormField(
                initialValue: _weight.toString(),
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _reps.toString(),
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid number of reps';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reps = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateWorkout,
                child: Text('Update Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
