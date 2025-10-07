class Recipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final int prepTime; // in minutes
  final int cookTime; // in minutes

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.prepTime,
    required this.cookTime,
  });
}
