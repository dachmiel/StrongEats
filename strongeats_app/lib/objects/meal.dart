import 'food.dart';

class Meal {
  final String name; // name of meal
  // final String date;
  final List<Food> foods; // list of foods eaten that day
  bool isEaten;

  Meal({
    required this.name,
    required this.foods,
    // required this.date,
    this.isEaten = false,
  });
}
