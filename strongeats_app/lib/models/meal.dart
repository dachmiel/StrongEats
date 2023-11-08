import 'food.dart';

class Meal {
  final String name; // name of meal
  final List<Food> foods; // list of foods eaten that day
  bool isEaten;

  Meal({
    required this.name,
    required this.foods,
    this.isEaten = false,
  });
}
