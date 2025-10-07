import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample recipe data
  static final List<Recipe> recipes = [
    Recipe(
      name: "Chocolate Chip Cookies",
      description: "Classic homemade chocolate chip cookies that are soft and chewy",
      ingredients: [
        "2 1/4 cups all-purpose flour",
        "1 tsp baking soda",
        "1 tsp salt",
        "1 cup butter, softened",
        "3/4 cup granulated sugar",
        "3/4 cup brown sugar",
        "2 large eggs",
        "2 tsp vanilla extract",
        "2 cups chocolate chips"
      ],
      instructions: [
        "Preheat oven to 375°F (190°C)",
        "Mix flour, baking soda, and salt in a bowl",
        "Cream butter and sugars until fluffy",
        "Beat in eggs and vanilla",
        "Gradually blend in flour mixture",
        "Stir in chocolate chips",
        "Drop rounded tablespoons onto ungreased cookie sheets",
        "Bake 9-11 minutes until golden brown"
      ],
      imageUrl: "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400",
      prepTime: 15,
      cookTime: 11,
    ),
    Recipe(
      name: "Spaghetti Carbonara",
      description: "Creamy Italian pasta dish with eggs, cheese, and pancetta",
      ingredients: [
        "1 lb spaghetti",
        "6 oz pancetta, diced",
        "4 large eggs",
        "1 cup grated Parmesan cheese",
        "4 cloves garlic, minced",
        "1/2 cup heavy cream",
        "Salt and black pepper to taste",
        "Fresh parsley for garnish"
      ],
      instructions: [
        "Cook spaghetti according to package directions",
        "Cook pancetta in a large skillet until crispy",
        "Whisk eggs, Parmesan, and cream in a bowl",
        "Drain pasta and add to pancetta",
        "Remove from heat and quickly stir in egg mixture",
        "Season with salt and pepper",
        "Serve immediately with extra Parmesan"
      ],
      imageUrl: "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400",
      prepTime: 10,
      cookTime: 20,
    ),
    Recipe(
      name: "Chicken Stir Fry",
      description: "Quick and healthy chicken stir fry with vegetables",
      ingredients: [
        "1 lb chicken breast, sliced",
        "2 cups mixed vegetables (bell peppers, broccoli, carrots)",
        "3 cloves garlic, minced",
        "1 inch ginger, grated",
        "3 tbsp soy sauce",
        "2 tbsp oyster sauce",
        "1 tbsp sesame oil",
        "2 tbsp vegetable oil",
        "Green onions for garnish"
      ],
      instructions: [
        "Heat oil in a large wok or skillet",
        "Cook chicken until golden and cooked through",
        "Add garlic and ginger, stir for 30 seconds",
        "Add vegetables and stir-fry for 3-4 minutes",
        "Mix soy sauce and oyster sauce, add to pan",
        "Toss everything together and cook for 1 minute",
        "Garnish with green onions and serve over rice"
      ],
      imageUrl: "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400",
      prepTime: 15,
      cookTime: 15,
    ),
    Recipe(
      name: "Chocolate Cake",
      description: "Rich and moist chocolate cake perfect for any celebration",
      ingredients: [
        "2 cups all-purpose flour",
        "2 cups granulated sugar",
        "3/4 cup cocoa powder",
        "2 tsp baking powder",
        "1 1/2 tsp baking soda",
        "1 tsp salt",
        "1 cup milk",
        "1/2 cup vegetable oil",
        "2 large eggs",
        "2 tsp vanilla extract",
        "1 cup boiling water"
      ],
      instructions: [
        "Preheat oven to 350°F (175°C)",
        "Grease and flour two 9-inch cake pans",
        "Mix dry ingredients in a large bowl",
        "Add milk, oil, eggs, and vanilla",
        "Beat on medium speed for 2 minutes",
        "Stir in boiling water (batter will be thin)",
        "Pour into prepared pans",
        "Bake 30-35 minutes until toothpick comes out clean",
        "Cool in pans for 10 minutes, then remove to wire rack"
      ],
      imageUrl: "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400",
      prepTime: 20,
      cookTime: 35,
    ),
    Recipe(
      name: "Caesar Salad",
      description: "Classic Caesar salad with homemade croutons and dressing",
      ingredients: [
        "1 large head romaine lettuce",
        "1/2 cup grated Parmesan cheese",
        "1 cup croutons",
        "2 cloves garlic, minced",
        "1/4 cup olive oil",
        "2 tbsp lemon juice",
        "1 tsp Dijon mustard",
        "2 anchovy fillets",
        "Salt and pepper to taste"
      ],
      instructions: [
        "Wash and chop romaine lettuce",
        "Make dressing by blending garlic, olive oil, lemon juice, mustard, and anchovies",
        "Season dressing with salt and pepper",
        "Toss lettuce with dressing",
        "Add croutons and Parmesan cheese",
        "Toss again and serve immediately"
      ],
      imageUrl: "https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400",
      prepTime: 15,
      cookTime: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(recipe: recipe),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          recipe.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipe.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.prepTime + recipe.cookTime} min',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.restaurant,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${recipe.ingredients.length} ingredients',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
