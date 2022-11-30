import 'package:open_mensa/backend/meal_model.dart';

class Line {
  final String category;
  final List<Meal> meals;

  Line({required this.category, required this.meals});

  @override
  String toString() {
    String string = "$category: ";
    for (Meal element in meals) {string = "$string $element,";}
    return string;
  }
}
