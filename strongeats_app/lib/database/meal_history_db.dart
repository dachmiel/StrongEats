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

  Future deleteMeal(String mealName) async {
    try {
      // Delete the meal document
      await mealHistory.doc(uid).collection('userMeals').doc(mealName).delete();

      // Optionally, you can delete associated exercises if needed
      // await workoutHistory.doc(uid).collection('userWorkouts').doc(workoutName).collection('userExercises').get().then((querySnapshot) {
      //   querySnapshot.docs.forEach((doc) {
      //     doc.reference.delete();
      //   });
      // });
    } catch (e) {
      print('Error deleting meal: $e');
    }
  }

  Future deleteFood(String mealName, String foodName) async {
    try {
      // Delete the food document
      await mealHistory
          .doc(uid)
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
