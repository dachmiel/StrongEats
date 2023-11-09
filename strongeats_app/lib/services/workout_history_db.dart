import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/auth/uid.dart' as userID;

class WorkoutHistoryDB{

  final uid = userID.uid;

  // collection reference
  final CollectionReference workoutHistory = FirebaseFirestore.instance.collection('workoutHistory');

  Future updateWorkoutData(String date, String exercise, String sets, String reps, String weight) async {
    print('ran');
    print(uid);
    return await workoutHistory.doc(uid).collection('userWorkouts').doc(date).set({
      'exercise': exercise,
      'sets': sets,
      'reps': reps,
      'weight': weight
    });
  }

}