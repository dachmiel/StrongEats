import 'package:flutter/foundation.dart';
import 'package:strongeats/models/exercise.dart';
import 'package:strongeats/services/workout_history_db.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';
import 'package:strongeats/models/workout_list.dart';

class WorkoutData extends ChangeNotifier {
  List<WorkoutStream> workoutList = WorkoutHistoryDB().workouts.listen();
  /*[
    Workout(
      name: "Day 1",
      exercises: [
        Exercise(
          name: "Bench Press",
          weight: "85",
          reps: "12",
          sets: "3",
        ),
        Exercise(
          name: "Squats",
          weight: "135",
          reps: "12",
          sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Day 2",
      exercises: [
        Exercise(
          name: "Deadlift",
          weight: "85",
          reps: "12",
          sets: "3",
        ),
        Exercise(
          name: "Bicep Curls",
          weight: "135",
          reps: "12",
          sets: "3",
        ),
      ],
    )
  ];*/

  // get the list of workouts
/*
  List<WorkoutStream> getWorkoutList() {
    return _WorkoutListState.workouts;
  }
*/
  // get length of a given workout

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add a workout

  void addWorkout(String workoutName){
    //workoutList.add(Workout(name: name, exercises: []));
    WorkoutHistoryDB().newWorkout(
      Workout(
        name: workoutName,
        exercises: []
      ));

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
      workoutList.forEach((workoutL) => workoutL.firstWhere((workout) => workout.name == workoutName)) as Workout;     // .firstWhere((workout) => workout.name == workoutName);

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
