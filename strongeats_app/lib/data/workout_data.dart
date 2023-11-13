import 'package:flutter/foundation.dart';
import 'package:strongeats/models/exercise.dart';
import 'package:strongeats/services/workout_history_db.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';
import 'package:strongeats/models/workout_list.dart' as listCreation;

class WorkoutData extends ChangeNotifier {
  final dummy = listCreation.getData();

  List<Workout> workoutList = listCreation.workoutListSnap;

  // get the list of workouts

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add a workout

  void addWorkout(String workoutName) {
    workoutList.add(Workout(name: workoutName, exercises: []));

    WorkoutHistoryDB().newWorkout(Workout(name: workoutName, exercises: []));

    // print("\n\n\n\n\n\n\n\n" + listCreation.printWorkoutHistory() + "\n\n\n\n\n\n\n");
    notifyListeners();
  }

  // add an exercise to a workout

  void addExercise(String workoutName, Exercise exercise) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(
        name: exercise.name,
        weight: exercise.weight,
        reps: exercise.reps,
        sets: exercise.sets,
      ),
    );

    notifyListeners();

    // find the workout and add exercise
    // if it does not exist, return error
  }

  // check off completed exercises/workout

  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  // return relevant workout object, given workout name

  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    //forEach((workoutL) => workoutL.firstWhere((workout) => workout.name == workoutName)) as Workout;     // .firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return relevant exercise object, given workout + exercise name

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
