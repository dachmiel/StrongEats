import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strongeats/auth/uid.dart' as userID;
import 'package:strongeats/objects/meal.dart';
import 'package:strongeats/objects/food.dart';

class MealHistoryDB {
  final uid = userID.uid;

  // collection reference
  final CollectionReference mealHistory =
      FirebaseFirestore.instance.collection('mealHistory');

  Future newMeal(Meal meal) async {
    return await mealHistory
        .doc(uid)
        .collection('userMeals')
        .doc(meal.name)
        .set({'name': meal.name});
  }

  Future updateMealData(String name, Food food) async {
    return await mealHistory
        .doc(uid)
        .collection('userMeals')
        .doc(name)
        .collection('foods')
        .doc(food.name)
        .set({
      'name': food.name,
      'weight': food.weight,
      'servings': food.servings,
      'calories': food.calories,
      'protein': food.proteins,
      'carb': food.carbs,
      'fat': food.fats,
    });
  }
}
