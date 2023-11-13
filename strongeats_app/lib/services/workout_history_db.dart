import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/auth/uid.dart' as userID;
import 'package:strongeats/models/exercise.dart';
import 'package:strongeats/models/workout.dart';

class WorkoutHistoryDB {
  final uid = userID.uid;

  // collection reference
  final CollectionReference workoutHistory =
      FirebaseFirestore.instance.collection('workoutHistory');

  Future newWorkout(Workout workout) async {
    return await workoutHistory
        .doc(uid)
        .collection('userWorkouts')
        .doc(workout.name)
        .set({'name': workout.name});
  }

  Future updateWorkoutData(String date, Exercise exercise) async {
    return await workoutHistory
        .doc(uid)
        .collection('userWorkouts')
        .doc(date)
        .collection('userExercises')
        .doc(exercise.name)
        .set({
      'name': exercise.name,
      'sets': exercise.sets,
      'reps': exercise.reps,
      'weight': exercise.weight
    });
  }
}
