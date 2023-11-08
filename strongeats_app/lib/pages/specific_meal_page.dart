import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongeats/data/meal_data.dart';

class MealPage extends StatefulWidget {
  final String mealName;
  const MealPage({super.key, required this.mealName});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MealData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.mealName),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemCount: value.numberOfFoodsInMeal(widget.mealName),
          itemBuilder: (context, index) => ListTile(
            title:
                Text(value.getRelevantMeal(widget.mealName).foods[index].name),
          ),
        ),
      ),
    );
  }
}
