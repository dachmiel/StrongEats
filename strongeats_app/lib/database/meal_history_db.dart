import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strongeats/auth/uid.dart';
import 'package:strongeats/objects/meal.dart';
import 'package:strongeats/objects/food.dart';

class MealHistoryDB {
  // collection reference
  final CollectionReference mealHistory =
      FirebaseFirestore.instance.collection('mealHistory');

  Future newMeal(Meal meal) async {
    return await mealHistory
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('userMeals')
        .doc(meal.name)
        .set({'name': meal.name});
  }

  Future addFood(String mealName, Food food) async {
    return await mealHistory
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('userMeals')
        .doc(mealName)
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

  Future deleteMeal(String mealName) async {
    try {
      // Delete the meal document
      await mealHistory
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('userMeals')
          .doc(mealName)
          .delete();

      // delete associated foods
      await mealHistory
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('userMeals')
          .doc(mealName)
          .collection('userFoods')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('Error deleting meal: $e');
    }
  }

  Future deleteFood(String mealName, String foodName) async {
    try {
      // Delete the food document
      await mealHistory
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('userMeals')
          .doc(mealName)
          .collection('userFoods')
          .doc(foodName)
          .delete();
    } catch (e) {
      print('Error deleting food: $e');
    }
  }
}
