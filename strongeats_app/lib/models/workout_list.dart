import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:strongeats/models/workout.dart';

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
}