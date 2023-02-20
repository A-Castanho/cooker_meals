class Ingredient {
  final String name;
  final int amount;
  final String? measureUnit;
  final List<Ingredient>? alternatives;

  Ingredient(
      {required this.name,
      required this.amount,
      this.measureUnit,
      this.alternatives});
}
