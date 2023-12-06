import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/custom_classes/text_box.dart';
import 'package:strongeats/objects/height.dart';
import 'package:strongeats/objects/sex.dart';

class UserDetails extends StatefulWidget {
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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

  Future<void> editSexField() async {
    String currentSex =
        ""; //change this to be whatever is currently stored in the database, and for the scroll to be selected to that option by default
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Sex",
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                itemExtent: 35,
                physics: FixedExtentScrollPhysics(),
                onSelectedItemChanged: (value) {
                  setState(
                    () {
                      if (value == 0) {
                        currentSex = 'Male';
                      } else {
                        currentSex = 'Female';
                      }
                    },
                  );
                },
                childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 2,
                    builder: (context, index) {
                      if (index == 0) {
                        return MySex(
                          isItMale: true,
                        );
                      } else {
                        return MySex(
                          isItMale: false,
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () async {
              // update in firestore
              if (currentSex.trim().length == 0) {
                //if nothing is picked, choose male by default
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({'sex': 'Male'});
              } else {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({'sex': currentSex});
              }
              Navigator.of(context).pop(currentSex);
            },
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
  }

  Future<void> editHeightField() async {
    String currentHeight = "";
    String currentFeet = "";
    String currentInches = "";
    String currentUnit = "in";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Height",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  // feet wheel
                  Container(
                    width: 70,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 35,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (value) {
                        setState(
                          () {
                            currentFeet = value.toString();
                          },
                        );
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 13, //states.length
                          builder: (context, index) {
                            return MyFeet(
                              feet: index,
                              selectedColor: currentFeet == index
                                  ? Colors.black
                                  : Colors.white60,
                            );
                          }),
                    ),
                  ),
                  // inches wheel
                  Container(
                    width: 70,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 35,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (value) {
                        setState(
                          () {
                            currentInches = value.toString();
                          },
                        );
                        print(currentInches);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 12,
                          builder: (context, index) {
                            return MyInches(
                              inches: index,
                            );
                          }),
                    ),
                  ),
                  // units wheel
                  Container(
                    width: 70,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 35,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (value) {
                        setState(
                          () {
                            if (value == 0) {
                              currentUnit = 'cm';
                            } else {
                              currentUnit = 'in';
                            }
                          },
                        );
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 2,
                          builder: (context, index) {
                            if (index == 0) {
                              return CmIn(
                                isItCm: true,
                              );
                            } else {
                              return CmIn(
                                isItCm: false,
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(currentHeight),
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
    if (currentHeight.trim().length > 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({'height': currentHeight});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
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
                    'My Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // age
                MyTextBox(
                  text: userData['age'],
                  sectionName: 'Age',
                  onPressed: () => editField('age'),
                ),

                // sex
                MyTextBox(
                  text: userData['sex'],
                  sectionName: 'Sex',
                  onPressed: () => editSexField(),
                ),

                // weight
                MyTextBox(
                  text: userData['weight'],
                  sectionName: 'Weight',
                  onPressed: () => editField('weight'),
                ),

                // height
                MyTextBox(
                  text: userData['height'],
                  sectionName: 'Height',
                  onPressed: () => editHeightField(),
                ),

                // BMI
                MyTextBox(
                  text: userData['bmi'],
                  sectionName: 'BMI',
                  onPressed: () => editField('bmi'),
                ),

                // body fat
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
