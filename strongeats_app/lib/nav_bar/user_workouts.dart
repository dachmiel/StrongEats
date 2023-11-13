import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongeats/components/customTextField.dart';
import 'package:strongeats/components/registerTextField.dart';
import 'package:strongeats/data/workout_data.dart';
import '../pages/specific_workout_page.dart';
import 'package:strongeats/auth/uid.dart';

class UserWorkouts extends StatefulWidget {
  @override
  State<UserWorkouts> createState() => _UserWorkoutsState();
}

class _UserWorkoutsState extends State<UserWorkouts> {
  // text controller
  final _newWorkoutNameController = TextEditingController();
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

  // save workout
  void save() {
    // get workout name from text controller
    String newWorkoutName = _newWorkoutNameController.text;
    // add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
          stream: _workoutsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Connection error');
            }
            // stream is connected but data is not coming yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }

            var docs = snapshot.data!.docs;
            // return Text('${docs.length}');
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(
                              docs[index]['name'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => goToWorkoutPage(
                                docs[index]['name'],
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
      ),
    );
  }
}
