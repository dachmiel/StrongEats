import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import '../pages/user_workout_page.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/objects/workout.dart';
import 'package:strongeats/database/workout_history_db.dart';

class UserWorkouts extends StatefulWidget {
  @override
  State<UserWorkouts> createState() => _UserWorkoutsState();
}

class _UserWorkoutsState extends State<UserWorkouts> {
  // text controller
  final _newWorkoutNameController = TextEditingController();
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
        content: CustomTextField(
          controller: _newWorkoutNameController,
          text: 'Workout name',
          obscureText: false,
          borderColor: Colors.grey,
          fillColor: Colors.white,
          textColor: Colors.black,
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
    String newWorkoutName = _newWorkoutNameController.text;
    // add empty workout to database
    WorkoutHistoryDB().newWorkout(Workout(name: newWorkoutName, exercises: []));

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
    _newWorkoutNameController.clear();
  }

  // build this users list of workouts based on stored info from database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
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
            return const Text('Loading...');
          }
          // successful connection and data received
          var docs = snapshot.data!.docs;

          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) => Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(docs[index]['name']),
                          onDismissed: (direction) {
                            delete(docs[index]['name']);
                          },
                          background: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 16.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            height: 100, // Set the height
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  docs[index]['name'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                                onTap: () =>
                                    goToWorkoutPage(docs[index]['name']),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
