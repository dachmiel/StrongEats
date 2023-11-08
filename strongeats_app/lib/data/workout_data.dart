import 'package:flutter/foundation.dart';
import 'package:strongeats/models/exercise.dart';

import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  List<Workout> workoutList = [
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
  ];

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

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // add an exercise to a workout

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
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
