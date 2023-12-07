import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import 'package:strongeats/custom_classes/food_tile.dart';
import 'package:strongeats/objects/food.dart';
import 'package:strongeats/database/meal_history_db.dart';

class MealPage extends StatefulWidget {
  final String mealName;
  const MealPage({super.key, required this.mealName});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  late Stream<QuerySnapshot> _foodsStream;

  // read food stream from database based on user id and workout name
  @override
  void initState() {
    super.initState();
    _foodsStream = FirebaseFirestore.instance
        .collection('mealHistory')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('userMeals')
        .doc(widget.mealName)
        .collection('userFoods')
        .snapshots();
  }

  // text controlleres
  final _newFoodNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _servingsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  // create a new food
  void createNewFood() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a food'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // collect food name
            CustomTextField(
              controller: _newFoodNameController,
              text: 'Food Name',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 5),

            // collect weight
            CustomTextField(
              controller: _weightController,
              text: 'Weight',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 5),

            // collect servings
            CustomTextField(
              controller: _servingsController,
              text: 'Servings',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 5),

            // collect calories
            CustomTextField(
              controller: _caloriesController,
              text: 'Calories',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 5),

            // collect proteins
            CustomTextField(
              controller: _proteinsController,
              text: 'Proteins',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 5),

            // collect carbs
            CustomTextField(
              controller: _carbsController,
              text: 'Carbs',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
            const SizedBox(height: 5),

            // fats
            CustomTextField(
              controller: _fatsController,
              text: 'Fats',
              obscureText: false,
              fillColor: Colors.white,
              borderColor: Colors.grey,
              textColor: Colors.black,
            ),
          ],
        ),
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

  // save food
  void save() {
    // store info from text controller
    String newFoodName = _newFoodNameController.text;
    String weight = _weightController.text;
    String servings = _servingsController.text;
    String calories = _caloriesController.text;
    String proteins = _proteinsController.text;
    String carbs = _carbsController.text;
    String fats = _fatsController.text;

    // create a new food object based on info collected from user
    Food newFood = Food(
      name: newFoodName,
      weight: weight,
      servings: servings,
      calories: calories,
      proteins: proteins,
      carbs: carbs,
      fats: fats,
    );

    MealHistoryDB().addFood(widget.mealName, newFood);

    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear
  void clear() {
    _newFoodNameController.clear();
    _weightController.clear();
    _servingsController.clear();
    _caloriesController.clear();
    _proteinsController.clear();
    _carbsController.clear();
    _fatsController.clear();
  }

  // build this users list of foods based on stored info from database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealName),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[900],
        onPressed: createNewFood,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _foodsStream,
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
                'Add a food to your meal!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) => FoodTile(
              foodName: docs[index]['name'],
              weight: docs[index]['weight'],
              servings: docs[index]['servings'],
              calories: docs[index]['calories'],
              proteins: docs[index]['protein'],
              carbs: docs[index]['carb'],
              fats: docs[index]['fat'],
              // isCompleted: value
              //     .getRelevantWorkout(widget.workoutName)
              //     .exercises[index]
              //     .isCompleted,
              // onCheckBoxChanged: (val) => onCheckBoxChanged(
              //     widget.workoutName,
              //     value
              //         .getRelevantWorkout(widget.workoutName)
              //         .exercises[index]
              //         .name),
            ),
          );
        },
      ),
    );
  }
}
