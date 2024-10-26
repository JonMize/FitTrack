import 'package:flutter/material.dart';
import 'db_helper.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final DBHelper _dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  String _exercise = '';
  int _weight = 0;
  int _reps = 0;

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

  void _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _dbHelper.insertWorkout({
        'exercise': _exercise,
        'weight': _weight,
        'reps': _reps,
      });
      _loadWorkouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
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
                    onPressed: _addWorkout,
                    child: Text('Add Workout'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_workouts[index]['exercise']),
                    subtitle: Text(
                        'Weight: ${_workouts[index]['weight']} kg, Reps: ${_workouts[index]['reps']}'),
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
