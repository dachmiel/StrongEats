import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import 'package:strongeats/objects/meal.dart';
import 'package:strongeats/database/meal_history_db.dart';
import '../pages/user_meal_page.dart';

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
      .doc(uid)
      .collection('userMeals')
      .snapshots();

  // create a new meal
  void createNewMeal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new meal"),
        content: CustomTextField(
          controller: _newMealNameController,
          text: 'Meal name',
          obscureText: false,
          borderColor: Colors.grey,
          fillColor: Colors.white,
          textColor: Colors.black,
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
    MealHistoryDB().newMeal(Meal(name: newMealName, foods: []));

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
    _newMealNameController.clear();
  }

  // build this users list of meals based on info from database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
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
            return const Text('Loading...');
          }

          var docs = snapshot.data!.docs;
          // return Text('${docs.length}');
          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                            docs[index]['name'],
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => goToMealPage(
                              docs[index]['name'],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
