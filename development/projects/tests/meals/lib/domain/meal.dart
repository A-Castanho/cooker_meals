import 'package:meals/domain/ingredient.dart';

class Meal {
  String? id;
  final String name;
  final String? description;
  final String? imagePath;
  MealDetails? details;

  Meal(id,
      {required this.name, this.description, this.imagePath, this.details});
}

class MealDetails {
  final List<Ingredient> ingredients;
  final List<Ingredient> steps;

  MealDetails({required this.ingredients, required this.steps});
}
