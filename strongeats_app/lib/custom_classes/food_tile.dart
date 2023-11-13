import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  final String foodName;
  final String weight;
  final String servings;
  final String calories;
  final String proteins;
  final String carbs;
  final String fats;

  FoodTile({
    super.key,
    required this.foodName,
    required this.weight,
    required this.servings,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(
          foodName,
        ),
        subtitle: Row(
          children: [
            // weight
            Chip(
              label: Text(weight + "lbs"),
            ),
            // servings
            Chip(
              label: Text(servings + " servings"),
            ),

            // calories
            Chip(
              label: Text(calories + " calories"),
            ),

            // protein
            Chip(
              label: Text(proteins + " grams of protein"),
            ),

            // carbs
            Chip(
              label: Text(carbs + " grams of carbs"),
            ),

            // fat
            Chip(
              label: Text(fats + " grams of fat"),
            ),
          ],
        ),
      ),
    );
  }
}
