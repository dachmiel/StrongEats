import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import 'package:strongeats/custom_classes/workout_meal_list_tile.dart';
import '../pages/user_workout_page.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/objects/workout.dart';
import 'package:strongeats/database/workout_history_db.dart';
import 'package:intl/intl.dart';

class UserWorkouts extends StatefulWidget {
  @override
  State<UserWorkouts> createState() => _UserWorkoutsState();
}

class _UserWorkoutsState extends State<UserWorkouts> {
  // text controller
  final _workoutDateController = TextEditingController();
  // read this users workouts from database
  final _workoutsStream = FirebaseFirestore.instance
      .collection('workoutHistory')
      .doc(uid)
      .collection('userWorkouts')
      .snapshots();

  // create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new workout"),
        content: TextField(
          controller: _workoutDateController,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Workout Date',
            prefixIcon: Icon(Icons.calendar_today),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          readOnly: true,
          onTap: () {
            _selectDate();
          },
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      String formattedDate = DateFormat("MMMM dd, yyyy").format(_picked);
      setState(() {
        _workoutDateController.text = formattedDate.toString();
      });
    }
  }

  // go to a specific workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  // save workout into database
  void save() {
    // get workout name from text controller
    String newWorkoutDate = _workoutDateController.text;
    // add empty workout to database
    WorkoutHistoryDB().newWorkout(Workout(name: newWorkoutDate, exercises: []));

    Navigator.pop(context);
    clear();
  }

  void delete(String workoutName) {
    WorkoutHistoryDB().deleteWorkout(workoutName);
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear
  void clear() {
    _workoutDateController.clear();
  }

  // build this users list of workouts based on stored info from database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[900],
        onPressed: createNewWorkout,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // constantly update users workouts based on database
      body: StreamBuilder(
        stream: _workoutsStream,
        builder: (context, snapshot) {
          // stream connection error
          if (snapshot.hasError) {
            return const Text('Connection error');
          }
          // stream is connected but data is not coming yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // successful connection and data received
          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            // User has no workouts, display a message
            return Center(
              child: Text(
                'Create a new workout!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                ),
              ),
            );
          }

          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      child: MyListTile(
                          delete: delete,
                          docs: docs,
                          goToWorkoutOrMealPage: goToWorkoutPage)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
