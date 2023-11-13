import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/models/workout.dart';
import 'package:strongeats/auth/uid.dart';

// collection reference
final CollectionReference workoutHistory = FirebaseFirestore.instance
    .collection('workoutHistory')
    .doc(uid)
    .collection('userWorkouts');

List<dynamic> workoutNames = [];
List<Workout> workoutListSnap = [];

Future<void> getData() async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await workoutHistory.get();

  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.id).toList();

  workoutNames = allData;

  workoutNames.forEach(
      (element) => workoutListSnap.add(Workout(name: element, exercises: [])));
  print(workoutNames);
  print(workoutListSnap);
}

List<dynamic> printWorkoutHistory() {
  return workoutListSnap;
}


/*
class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  @override
  Widget build(BuildContext context) {

    final workouts = Provider.of<List<WorkoutStream>>(context);

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        return 
      }
    );
  }
} */

