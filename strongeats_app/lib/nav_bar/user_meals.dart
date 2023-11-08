import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongeats/data/meal_data.dart';
import '../pages/specific_meal_page.dart';

class UserMeals extends StatefulWidget {
  @override
  State<UserMeals> createState() => _UserMealsState();
}

class _UserMealsState extends State<UserMeals> {
  // text controller
  final _newMealNameController = TextEditingController();

  // create a new meal
  void createNewMeal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create new meal"),
        content: TextField(
          controller: _newMealNameController,
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
    // add meal to mealdata list
    Provider.of<MealData>(context, listen: false).addMeal(newMealName);

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

  @override
  Widget build(BuildContext context) {
    return Consumer<MealData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: createNewMeal,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ListView.builder(
                      itemCount: value.getMealList().length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          value.getMealList()[index].name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              goToMealPage(value.getMealList()[index].name),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
