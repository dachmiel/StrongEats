import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import 'package:strongeats/custom_classes/exercise_tile.dart';
import 'package:strongeats/objects/exercise.dart';
import 'package:strongeats/database/workout_history_db.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late Stream<QuerySnapshot> _exercisesStream;

  // read exercise stream from database based on user id and workout name
  @override
  void initState() {
    super.initState();
    _exercisesStream = FirebaseFirestore.instance
        .collection('workoutHistory')
        .doc(uid)
        .collection('userWorkouts')
        .doc(widget.workoutName)
        .collection('userExercises')
        .snapshots();
  }

  // text controlleres
  final _newExerciseNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();

  // check if box was tapped
  //void onCheckBoxChanged(String workoutName, String exerciseName) {
  //  Provider.of<WorkoutData>(context, listen: false)
  //      .checkOffExercise(workoutName, exerciseName);
  //}

  // collect new exercise info from user
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // exercise name
            CustomTextField(
              controller: _newExerciseNameController,
              text: 'Exercise Name',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),

            // weight
            CustomTextField(
              controller: _weightController,
              text: 'Weight (lbs)',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),

            // reps
            CustomTextField(
              controller: _repsController,
              text: 'Reps',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),

            // sets
            CustomTextField(
              controller: _setsController,
              text: 'Sets',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            )
          ],
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

  // save exercise
  void save() {
    // get exercise name from text controller
    String newExerciseName = _newExerciseNameController.text;
    String weight = _weightController.text;
    String reps = _repsController.text;
    String sets = _setsController.text;

    Exercise newExercise =
        Exercise(name: newExerciseName, weight: weight, reps: reps, sets: sets);

    // add exercise to database based on workout name and the new exercise
    WorkoutHistoryDB().newExercise(widget.workoutName, newExercise);

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
    _newExerciseNameController.clear();
    _weightController.clear();
    _repsController.clear();
    _setsController.clear();
  }

  // build this users list of exercises based on stored info from database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewExercise,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _exercisesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Connection error');
          }
          // stream is connected but data is not coming yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) => ExerciseTile(
              exerciseName: docs[index]['name'],
              weight: docs[index]['weight'],
              reps: docs[index]['reps'],
              sets: docs[index]['sets'],
              // isCompleted: value
              //     .getRelevantWorkout(widget.workoutName)
              //     .exercises[index]
              //     .isCompleted,
              // onCheckBoxChanged: (val) => onCheckBoxChanged(
              //     widget.workoutName,
              //     value
              //         .getRelevantWorkout(widget.workoutName)
              //         .exercises[index]
              //         .name),
            ),
          );
        },
      ),
    );
  }
}
