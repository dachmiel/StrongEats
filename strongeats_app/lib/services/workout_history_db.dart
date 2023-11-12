import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/auth/uid.dart' as userID;
import 'package:strongeats/models/exercise.dart';
import 'package:strongeats/models/workout.dart';

class WorkoutHistoryDB{

  final uid = userID.uid;

  // collection reference
  final CollectionReference workoutHistory = FirebaseFirestore.instance.collection('workoutHistory');

  Future newWorkout(Workout workout) async {
    return await workoutHistory.doc(uid).collection('userWorkouts').doc(workout.name).set({'reps': 0});
  }
  
  Future updateWorkoutData(String date, Exercise exercise) async {
    return await workoutHistory.doc(uid).collection('userWorkouts').doc(date).collection('userExercises').doc(exercise.name).set({
      'sets': exercise.sets,
      'reps': exercise.reps,
      'weight': exercise.weight
    });
  }

  // get workout stream
  Stream<List<WorkoutStream>> get workouts {
    return workoutHistory.doc(uid).collection('userWorkouts').snapshots()
      .map(_workoutListFromSnapshot);
  }

  // get a workout list from snapshot
  List<WorkoutStream> _workoutListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((document){
      return WorkoutStream(
        name: document.toString(),
        exercises: workoutHistory.doc(uid).collection('userWorkouts').doc(document.toString()).collection('userExercises')
          .snapshots().map(_exerciseListFromSnapshot)
        );
      }).toList();
    }
  }

  // get an exercise list from snapshot
  List<Exercise> _exerciseListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((document){
      return Exercise(
        name: document.toString(),
        weight: document.get('weight'),
        sets: document.get('sets'),
        reps: document.get('reps')
      );
    }).toList();
  }


/*
  Future readWorkoutData() async{
    var querySnapshot =  await workoutHistory.doc(uid).collection('userWorkouts').get();
    return querySnapshot.docs;
  }

  List<Workout> giveWorkoutData(){
    Future<dynamic> workoutRaw = readWorkoutData();
    List<Workout> userWorkouts = [];
    for (var workoutData in workoutRaw.){
      userWorkouts.add(Workout(name: workoutData.toString(), exercises: workoutData.data()['exercises']));
    }
    return userWorkouts;
  }
  */
