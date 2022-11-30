class Meal {
  String name;
  double price; //euro

  Meal({required this.name, required this.price});

  @override
  String toString() {
    return "$name: $price";
  }
}
