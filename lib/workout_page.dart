import 'package:flutter/material.dart';
import 'db_helper.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final DBHelper _dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _sets = [];

  @override
  void initState() {
    super.initState();
    _addSet(); // Add the first set row when the page is loaded
  }

  // Add a new set (exercise, weight, reps) row
  void _addSet() {
    setState(() {
      _sets.add({
        'exercise': '',
        'weight': 0,
        'reps': 0,
      });
    });
  }

  // Save the entire workout to the database
  void _finishWorkout() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the current date and format it for the workout label
      DateTime now = DateTime.now();
      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      print("Saving workout for date: $formattedDate");
      print("Workout details: $_sets");

      // Save each set (exercise, weight, reps) along with the date
      for (var set in _sets) {
        await _dbHelper.insertWorkout({
          'exercise': set['exercise'],
          'weight': set['weight'],
          'reps': set['reps'],
          'date': formattedDate, // The date label for this workout
        });
      }

      // After saving the workout, return to the home page
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  // Function to show an edit dialog
  void _editSet(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final exerciseController =
            TextEditingController(text: _sets[index]['exercise']);
        final weightController =
            TextEditingController(text: _sets[index]['weight'].toString());
        final repsController =
            TextEditingController(text: _sets[index]['reps'].toString());

        return AlertDialog(
          title: Text('Edit Set'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: exerciseController,
                decoration: InputDecoration(labelText: 'Exercise'),
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Update the set data immediately upon saving
                  _sets[index]['exercise'] = exerciseController.text;
                  _sets[index]['weight'] = int.parse(weightController.text);
                  _sets[index]['reps'] = int.parse(repsController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
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
              Expanded(
                child: ListView.builder(
                  itemCount: _sets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () =>
                            _editSet(index), // Make the row tappable to edit
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: _sets[index]['exercise'],
                                decoration:
                                    InputDecoration(labelText: 'Exercise'),
                                readOnly:
                                    true, // Make it read-only to force edit through dialog
                                onTap: () =>
                                    _editSet(index), // Open edit dialog on tap
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                initialValue: _sets[index]['weight'].toString(),
                                decoration:
                                    InputDecoration(labelText: 'Weight (kg)'),
                                readOnly: true, // Make it read-only
                                onTap: () =>
                                    _editSet(index), // Open edit dialog on tap
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                initialValue: _sets[index]['reps'].toString(),
                                decoration: InputDecoration(labelText: 'Reps'),
                                readOnly: true, // Make it read-only
                                onTap: () =>
                                    _editSet(index), // Open edit dialog on tap
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addSet, // Change to "Add Set"
                child: Text('Add Set'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _finishWorkout,
                child: Text('Finish Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
