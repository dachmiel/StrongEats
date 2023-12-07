import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
        content: TextFormField(
          autofocus: true,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD32F2F),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD32F2F),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // save button
          ElevatedButton(
            onPressed: () {
              if (validateInput(newValue)) {
                // Valid input, save to Firestore
                Navigator.of(context).pop(newValue);
                updateFirestore(field, newValue);
              } else {
                // Invalid input, show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.grey[900],
                    content: Text(
                      "Invalid input. Please enter a valid value.",
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // cancel button
          ElevatedButton(
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

  void updateFirestore(String field, String newValue) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({field: newValue});
  }

  bool validateInput(String input) {
    if (input.isEmpty) {
      return false; // Empty input is considered invalid
    }

    final doubleRegex = RegExp(r'^\d*\.?\d+$');
    if (!doubleRegex.hasMatch(input)) {
      return false; // Input contains non-numeric characters
    }

    double value = double.parse(input);
    if (value < 0) {
      return false; // Input is a negative number
    }

    return true; // Input is valid
  }

  Future<void> editSexField() async {
    // Retrieve user's current height from Firebase
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    String currentSex = userDoc.get('sex') ?? "";

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
                controller: FixedExtentScrollController(
                  initialItem: currentSex == 'Male' ? 0 : 1,
                ),
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
          ElevatedButton(
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
          ElevatedButton(
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

    // Retrieve user's current height from Firebase
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    String userHeight = userDoc.get('height') ?? "0'0";
    List<String> heightParts = userHeight.split("'");
    if (heightParts.length == 2) {
      currentFeet = heightParts[0];
      currentInches = heightParts[1];
    }
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
                      controller: FixedExtentScrollController(
                        initialItem: int.tryParse(currentFeet) ?? 0,
                      ),
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
                      controller: FixedExtentScrollController(
                        initialItem: int.tryParse(currentInches) ?? 0,
                      ),
                      onSelectedItemChanged: (value) {
                        setState(
                          () {
                            currentInches = value.toString();
                          },
                        );
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
                              currentUnit = 'in';
                            }
                            //  else {
                            //   currentUnit = 'in';
                            // }
                          },
                        );
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 1,
                          builder: (context, index) {
                            if (index == 0) {
                              return CmIn(
                                isItCm: false,
                              );
                            }
                            // else {
                            //   return CmIn(
                            //     isItCm: false,
                            //   );
                            // }
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
          ElevatedButton(
            onPressed: () async {
              currentHeight = currentFeet + "'" + currentInches;
              // update in firestore
              if (currentHeight.trim().length == 1) {
                //if nothing is picked, choose male by default
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({'height': "0'0"});
              } else if (currentInches.trim().length == 0) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({'height': currentFeet + "'0"});
              } else if (currentFeet.trim().length == 0) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({'height': "0'" + currentInches});
              } else {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({'height': currentHeight});
              }
              Navigator.of(context).pop(currentHeight);
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // cancel button
          ElevatedButton(
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

  calculateAge(DateTime birthdate) {
    DateTime now = DateTime.now();
    int age = now.year - birthdate.year;

    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }

    // Use the age as needed
    return age;
  }

  void saveAge(int age) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'age': age.toString()});
  }

  void saveBirthday(DateTime birthday) async {
    // Convert DateTime to a formatted string
    String formattedBirthday = birthday.toIso8601String();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'birthday': formattedBirthday});
  }

  Future<void> editAgeField() async {
    DateTime dateTime = DateTime.now();
    // Retrieve user's current height from Firebase
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    String currentAge = userDoc.get('age') ?? "0";
    String birthdayString = userDoc.get('birthday') ?? "";

    // Convert birthday string to DateTime
    DateTime userBirthday = DateTime.tryParse(birthdayString) ?? dateTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              "Birthday",
              style: const TextStyle(color: Colors.white),
            ),
            content: Container(
              width:
                  MediaQuery.of(context).size.width * 0.8, // Set the width here

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                      initialDateTime: userBirthday,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() => dateTime = newTime);
                      },
                      use24hFormat: true,
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          saveAge(calculateAge(dateTime));
                          saveBirthday(dateTime);
                          Navigator.of(context).pop(dateTime);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                  onPressed: () => editAgeField(),
                ),

                // sex
                MyTextBox(
                  text: userData['sex'],
                  sectionName: 'Sex',
                  onPressed: () => editSexField(),
                ),

                // weight
                MyTextBox(
                  text: userData['weight'] + 'lbs',
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
