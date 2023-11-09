import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/auth/uid.dart' as userID;
import 'package:strongeats/models/exercise.dart';

class WorkoutHistoryDB{

  final uid = userID.uid;

  // collection reference
  final CollectionReference workoutHistory = FirebaseFirestore.instance.collection('workoutHistory');

  Future updateWorkoutData(String date, Exercise exercise) async {
    return await workoutHistory.doc(uid).collection('userWorkouts').doc(date).collection(exercise.name).add({
      'sets': exercise.sets,
      'reps': exercise.reps,
      'weight': exercise.weight
    });
  }

}