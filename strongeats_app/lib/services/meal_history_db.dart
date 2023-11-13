import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/auth/uid.dart' as userID;
import 'package:strongeats/models/meal.dart';
import 'package:strongeats/models/food.dart';

class MealHistoryDB {
  final uid = userID.uid;

  // collection reference
  final CollectionReference mealHistory =
      FirebaseFirestore.instance.collection('mealHistory');

  Future newMeal(Meal meal) async {
    return await mealHistory
        .doc(uid)
        .collection('mealDates')
        .doc(meal.date)
        .set({'name': meal.date});
  }

  Future updateMealData(Meal meal, Food food) async {
    return await mealHistory
        .doc(uid)
        .collection('mealDates')
        .doc(meal.date)
        .collection('userMeals')
        .doc(meal.name)
        .collection('foods')
        .doc(food.name)
        .set({
          'name': food.name,
          'weight': food.weight,
          'servings': food.servings,
          'calories': food.calories,
          'protein': food.protein,
          'carb': food.carb,
          'fat': food.fat
    });
  }
}