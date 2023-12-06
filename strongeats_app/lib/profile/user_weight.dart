import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/custom_classes/text_box.dart';

class UserWeight extends StatefulWidget {
  @override
  State<UserWeight> createState() => _UserWeightState();
}

class _UserWeightState extends State<UserWeight> {
  // user
  final _userStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // update in firestore
    if (newValue.trim().length > 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Goal Weight"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),

                // profile icon
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(
                  height: 10,
                ),

                // display user email
                Text(
                  FirebaseAuth.instance.currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),

                const SizedBox(
                  height: 50,
                ),

                // user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Current Goal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MyTextBox(
                  text: userData['goal weight'],
                  sectionName: 'Goal Weight',
                  onPressed: () => editField('goal weight'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error' + snapshot.error.toString(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
