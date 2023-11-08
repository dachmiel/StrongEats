import 'exercise.dart';

class Workout {
  final String name; // date of workout
  final List<Exercise> exercises; // list of exercises performed that day

  Workout({required this.name, required this.exercises});
}
