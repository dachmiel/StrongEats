import 'exercise.dart';

class Workout {
  final String name; // name of workout
  final List<Exercise> exercises; // list of exercises performed that day

  Workout({required this.name, required this.exercises});
}

class WorkoutStream {
  final String name; // name of workout
  final Stream<List<Exercise>> exercises; // list of exercises performed that day

  WorkoutStream({required this.name, required this.exercises});
}