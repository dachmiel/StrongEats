import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strongeats/auth/uid.dart' as userID;
import 'package:strongeats/objects/exercise.dart';
import 'package:strongeats/objects/workout.dart';

class WorkoutHistoryDB {
  // collection reference
  final CollectionReference workoutHistory =
      FirebaseFirestore.instance.collection('workoutHistory');

  // write a new workout to the DB
  Future newWorkout(Workout workout) async {
    return await workoutHistory
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('userWorkouts')
        .doc(workout.name)
        .set({'name': workout.name});
  }

  // write a new exercise to the DB
  Future addExercise(String workoutName, Exercise exercise) async {
    return await workoutHistory
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('userWorkouts')
        .doc(workoutName)
        .collection('userExercises')
        .doc(exercise.name)
        .set({
      'name': exercise.name,
      'sets': exercise.sets,
      'reps': exercise.reps,
      'weight': exercise.weight
    });
  }

  Future deleteWorkout(String workoutName) async {
    try {
      // Delete the workout document
      await workoutHistory
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('userWorkouts')
          .doc(workoutName)
          .delete();

      // delete associated exercises
      await workoutHistory
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('userWorkouts')
          .doc(workoutName)
          .collection('userExercises')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('Error deleting workout: $e');
    }
  }

  Future deleteExercise(String workoutName, String exerciseName) async {
    try {
      // Delete the workout document
      await workoutHistory
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('userWorkouts')
          .doc(workoutName)
          .collection('userExercises')
          .doc(exerciseName)
          .delete();
    } catch (e) {
      print('Error deleting exercise: $e');
    }
  }
}
