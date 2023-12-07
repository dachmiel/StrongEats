import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import 'package:strongeats/custom_classes/workout_meal_list_tile.dart';
import 'package:strongeats/objects/meal.dart';
import 'package:strongeats/database/meal_history_db.dart';
import '../pages/user_meal_page.dart';
import 'package:intl/intl.dart';

class UserMeals extends StatefulWidget {
  @override
  State<UserMeals> createState() => _UserMealsState();
}

class _UserMealsState extends State<UserMeals> {
  // text controller

  final _newMealNameController = TextEditingController();
  final _dateController = TextEditingController();
  // read this users meals from database
  final _mealsStream = FirebaseFirestore.instance
      .collection('mealHistory')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('userMeals')
      .snapshots();

  // create a new meal
  void createNewMeal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new meal"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Meal Date',
              prefixIcon: Icon(Icons.calendar_today),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            readOnly: true,
            onTap: () {
              _selectDate();
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _newMealNameController,
            text: 'Meal name',
            obscureText: false,
            borderColor: Colors.grey,
            fillColor: Colors.white,
            textColor: Colors.black,
          ),
        ]),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      String formattedDate = DateFormat("MMMM dd, yyyy").format(_picked);
      setState(() {
        _dateController.text = formattedDate.toString();
      });
    }
  }

  // go to a specific meal page
  void goToMealPage(String mealName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealPage(
            mealName: mealName,
          ),
        ));
  }

  // save meal
  void save() {
    // get meal name from text controller
    String newMealName = _newMealNameController.text;
    String date = _dateController.text;

    // add meal to mealdata list
    // Provider.of<MealData>(context, listen: false).addMeal(newMealName);
    MealHistoryDB().newMeal(Meal(name: (date + " " + newMealName), foods: []));

    Navigator.pop(context);
    clear();
  }

  // delete
  void delete(String mealName) {
    MealHistoryDB().deleteMeal(mealName);
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear
  void clear() {
    _newMealNameController.clear();
  }

  // build this users list of meals based on info from database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[900],
        onPressed: createNewMeal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: _mealsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Connection error');
          }
          // stream is connected but data is not coming yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            // User has no workouts, display a message
            return Center(
              child: Text(
                'Create a new meal!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                ),
              ),
            );
          }

          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      child: MyListTile(
                          delete: delete,
                          docs: docs,
                          goToWorkoutOrMealPage: goToMealPage)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
