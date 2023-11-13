import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final void Function(String) delete;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final void Function(String workoutName)? goToWorkoutOrMealPage;

  const MyListTile({
    super.key,
    required this.delete,
    required this.docs,
    required this.goToWorkoutOrMealPage,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: widget.docs.length,
        itemBuilder: (context, index) => Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(widget.docs[index]['name']),
          onDismissed: (direction) {
            widget.delete!(widget.docs[index]['name']);
          },
          background: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.red,
              // border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              // border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 100, // Set the height
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: ListTile(
                title: Text(
                  widget.docs[index]['name'].toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () =>
                    widget.goToWorkoutOrMealPage!(widget.docs[index]['name']),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
