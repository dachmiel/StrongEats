import 'package:flutter/foundation.dart';
import 'package:strongeats/models/food.dart';
import '../models/meal.dart';

class MealData extends ChangeNotifier {
  List<Meal> mealList = [
    Meal(
      name: "PB Sandwich",
      foods: [
        Food(
          name: "Peanut Butter",
          weight: "100",
          units: "grams",
          calories: "350",
        ),
        Food(
          name: "Bread",
          weight: "50",
          units: "grams",
          calories: "200",
        ),
      ],
    ),
    Meal(
      name: "Pasta",
      foods: [
        Food(
          name: "Spaghetti",
          weight: "220",
          units: "grams",
          calories: "500",
        ),
        Food(
          name: "Tomato Sauce",
          weight: "135",
          units: "grams",
          calories: "300",
        ),
      ],
    )
  ];

  // get the list of meals

  List<Meal> getMealList() {
    return mealList;
  }

  // get length of a given meals

  int numberOfFoodsInMeal(String mealName) {
    Meal relevantMeal = getRelevantMeal(mealName);
    return relevantMeal.foods.length;
  }

  // add a meal

  void addMeal(String name) {
    mealList.add(Meal(name: name, foods: []));

    notifyListeners();
  }

  // add a food to a meal

  void addFood(String mealName, String foodName, String weight, String units,
      String calories) {
    Meal relevantMeal = getRelevantMeal(mealName);

    relevantMeal.foods.add(
      Food(
        name: foodName,
        weight: weight,
        units: units,
        calories: calories,
      ),
    );

    notifyListeners();

    // find the meal and add food
    // if it does not exist, return error
  }

  // check off completed meal

  void checkOffMeal(String mealName) {
    Meal relevantMeal = getRelevantMeal(mealName);

    relevantMeal.isEaten = !relevantMeal.isEaten;

    notifyListeners();
  }

  // return relevant meal object, given meal name

  Meal getRelevantMeal(String mealName) {
    Meal relevantMeal = mealList.firstWhere((meal) => meal.name == mealName);

    return relevantMeal;
  }

  // return relevant food object, given meal + food name

  Food getRelevantFood(String mealName, String foodName) {
    Meal relevantMeal = getRelevantMeal(mealName);

    Food relevantFood =
        relevantMeal.foods.firstWhere((food) => food.name == foodName);

    return relevantFood;
  }
}
