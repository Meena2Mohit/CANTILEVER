import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class SampleRecipes {
  static List<Recipe> getSampleRecipes() {
    return [
      Recipe(
        title: 'Paneer Butter Masala',
        description: 'A popular and creamy curry made with paneer in a tomato and butter sauce.',
        prepTime: 30, servings: 4, category: 'Dinner', difficulty: 'Medium',
        tags: ['paneer', 'curry', 'main course', 'vegetarian'],
        ingredients: [
          Ingredient(name: 'Paneer, cubed', amount: 200, unit: 'gm'),
          Ingredient(name: 'Tomatoes, pureed', amount: 2, unit: 'cup'),
          Ingredient(name: 'Onion, finely chopped', amount: 1, unit: 'piece'),
          Ingredient(name: 'Ginger-garlic paste', amount: 1, unit: 'tbsp'),
          Ingredient(name: 'Fresh cream', amount: 0.25, unit: 'cup'),
          Ingredient(name: 'Butter', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Garam masala', amount: 1, unit: 'tsp'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Heat butter in a pan. Add the chopped onion and sauté until golden brown.',
          'Add ginger-garlic paste and cook for a minute.',
          'Pour in the tomato puree and cook until the oil starts to separate from the masala.',
          'Add spices and salt. Mix well.',
          'Add the paneer cubes and garam masala. Cook for 5 minutes.',
          'Stir in the fresh cream and cook for another minute. Do not boil after adding cream.',
          'Serve hot with naan or rice.',
        ],
      ),
      Recipe(
        title: 'Masala Chai',
        description: 'A classic Indian spiced tea, perfect for a refreshing start or a cozy evening.',
        prepTime: 10, servings: 2, category: 'Beverages', difficulty: 'Easy',
        tags: ['tea', 'quick', 'beverage'],
        ingredients: [
          Ingredient(name: 'Water', amount: 1, unit: 'cup'),
          Ingredient(name: 'Milk', amount: 1, unit: 'cup'),
          Ingredient(name: 'Black tea leaves', amount: 2, unit: 'tsp'),
          Ingredient(name: 'Sugar', amount: 2, unit: 'tsp'),
          Ingredient(name: 'Ginger, crushed', amount: 0.5, unit: 'inch'),
          Ingredient(name: 'Cardamom pods', amount: 2, unit: 'piece'),
        ],
        instructions: [
          'In a small saucepan, bring water to a boil with crushed ginger and cardamom pods.',
          'Add the tea leaves and let it simmer for 2 minutes.',
          'Pour in the milk and add sugar. Stir well.',
          'Bring the tea to a boil and then reduce the heat, letting it simmer for another 2-3 minutes.',
          'Strain the tea into cups and serve hot.',
        ],
      ),
      Recipe(
        title: 'Dal Tadka',
        description: 'A simple yet flavorful lentil curry tempered with spices.',
        prepTime: 25, servings: 4, category: 'Dinner', difficulty: 'Easy',
        tags: ['lentil', 'vegan', 'curry'],
        ingredients: [
          Ingredient(name: 'Toor Dal (pigeon peas)', amount: 1, unit: 'cup'),
          Ingredient(name: 'Onion, chopped', amount: 1, unit: 'piece'),
          Ingredient(name: 'Tomato, chopped', amount: 1, unit: 'piece'),
          Ingredient(name: 'Turmeric powder', amount: 0.5, unit: 'tsp'),
          Ingredient(name: 'Ghee or Oil', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Cumin seeds', amount: 1, unit: 'tsp'),
          Ingredient(name: 'Garlic, minced', amount: 2, unit: 'cloves'),
          Ingredient(name: 'Dry red chili', amount: 2, unit: 'piece'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Wash and pressure cook the dal with turmeric and salt for 3-4 whistles.',
          'Heat ghee/oil in a small pan for tempering (tadka).',
          'Add cumin seeds, dry red chili, and minced garlic. Sauté until fragrant.',
          'Pour the tempering over the cooked dal.',
          'Garnish with fresh coriander and serve hot.',
        ],
      ),
      Recipe(
        title: 'Aloo Gobi',
        description: 'A classic vegetarian Indian dish made with potatoes and cauliflower.',
        prepTime: 30, servings: 4, category: 'Lunch', difficulty: 'Easy',
        tags: ['vegetarian', 'vegan', 'potato', 'cauliflower'],
        ingredients: [
          Ingredient(name: 'Cauliflower, florets', amount: 1, unit: 'medium'),
          Ingredient(name: 'Potatoes, cubed', amount: 2, unit: 'medium'),
          Ingredient(name: 'Onion, sliced', amount: 1, unit: 'piece'),
          Ingredient(name: 'Turmeric powder', amount: 0.5, unit: 'tsp'),
          Ingredient(name: 'Coriander powder', amount: 1, unit: 'tsp'),
          Ingredient(name: 'Oil', amount: 3, unit: 'tbsp'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Heat oil in a pan, add onions and sauté until translucent.',
          'Add potatoes and cook for 5-7 minutes.',
          'Add cauliflower, turmeric, coriander powder, and salt.',
          'Mix well, cover, and cook on low heat for 15-20 minutes or until vegetables are tender.',
          'Stir occasionally to prevent sticking.',
          'Serve hot with roti or paratha.',
        ],
      ),
      Recipe(
        title: 'Chicken Tikka Masala',
        description: 'Creamy and rich grilled chicken curry, a favorite worldwide.',
        prepTime: 45, servings: 4, category: 'Dinner', difficulty: 'Medium',
        tags: ['chicken', 'curry', 'non-veg', 'main course'],
        ingredients: [
          Ingredient(name: 'Chicken breast, cubed', amount: 500, unit: 'gm'),
          Ingredient(name: 'Yogurt', amount: 1, unit: 'cup'),
          Ingredient(name: 'Tomato Puree', amount: 1, unit: 'cup'),
          Ingredient(name: 'Cream', amount: 0.5, unit: 'cup'),
          Ingredient(name: 'Tikka Masala spice mix', amount: 3, unit: 'tbsp'),
          Ingredient(name: 'Ginger-garlic paste', amount: 1, unit: 'tbsp'),
          Ingredient(name: 'Oil', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Marinate chicken with yogurt, ginger-garlic paste, and 1 tbsp of tikka masala for at least 1 hour.',
          'Grill or pan-fry the chicken until cooked through. Set aside.',
          'In a pan, heat oil, add tomato puree and the remaining tikka masala. Cook for 10 minutes.',
          'Add the grilled chicken and cream. Simmer for 5 minutes.',
          'Season with salt and serve hot.',
        ],
      ),
      Recipe(
        title: 'Samosa',
        description: 'A popular crispy pastry filled with spiced potatoes and peas.',
        prepTime: 50, servings: 8, category: 'Snacks', difficulty: 'Hard',
        tags: ['snack', 'fried', 'vegetarian'],
        ingredients: [
          Ingredient(name: 'All-purpose flour (Maida)', amount: 2, unit: 'cup'),
          Ingredient(name: 'Potatoes, boiled and mashed', amount: 4, unit: 'medium'),
          Ingredient(name: 'Green peas', amount: 0.5, unit: 'cup'),
          Ingredient(name: 'Cumin seeds', amount: 1, unit: 'tsp'),
          Ingredient(name: 'Garam masala', amount: 1, unit: 'tsp'),
          Ingredient(name: 'Oil', amount: 1, unit: 'for frying'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Prepare the dough using flour, salt, 2 tbsp oil, and water. Let it rest.',
          'For the filling, heat 1 tbsp oil, add cumin seeds, peas, and mashed potatoes.',
          'Add garam masala and salt. Mix well and let it cool.',
          'Roll out small discs from the dough, cut in half, and form into cones.',
          'Fill the cones with the potato mixture and seal the edges.',
          'Deep fry on low-medium heat until golden brown and crispy.',
        ],
      ),
      Recipe(
        title: 'Palak Paneer',
        description: 'A healthy and delicious spinach curry with Indian cottage cheese.',
        prepTime: 30, servings: 4, category: 'Dinner', difficulty: 'Medium',
        tags: ['spinach', 'paneer', 'healthy', 'vegetarian'],
        ingredients: [
          Ingredient(name: 'Spinach (Palak), blanched', amount: 250, unit: 'gm'),
          Ingredient(name: 'Paneer, cubed', amount: 200, unit: 'gm'),
          Ingredient(name: 'Onion, chopped', amount: 1, unit: 'piece'),
          Ingredient(name: 'Tomato, pureed', amount: 0.5, unit: 'cup'),
          Ingredient(name: 'Cream', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Garlic paste', amount: 1, unit: 'tsp'),
          Ingredient(name: 'Garam masala', amount: 0.5, unit: 'tsp'),
          Ingredient(name: 'Oil', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Puree the blanched spinach and set aside.',
          'Heat oil, sauté onions until golden. Add garlic paste and tomato puree. Cook for 5 minutes.',
          'Add the spinach puree, salt, and garam masala. Cook for 5-7 minutes.',
          'Add the paneer cubes and cream. Simmer for 2 minutes.',
          'Serve hot with roti or naan.',
        ],
      ),
      Recipe(
        title: 'Mango Lassi',
        description: 'A refreshing and sweet yogurt-based mango drink.',
        prepTime: 5, servings: 2, category: 'Beverages', difficulty: 'Easy',
        tags: ['mango', 'lassi', 'drink', 'quick'],
        ingredients: [
          Ingredient(name: 'Ripe mango, chopped', amount: 1, unit: 'cup'),
          Ingredient(name: 'Plain yogurt', amount: 1, unit: 'cup'),
          Ingredient(name: 'Milk', amount: 0.5, unit: 'cup'),
          Ingredient(name: 'Sugar', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Cardamom powder', amount: 1, unit: 'pinch'),
        ],
        instructions: [
          'Combine chopped mango, yogurt, milk, and sugar in a blender.',
          'Blend until smooth and creamy.',
          'Pour into glasses, garnish with a pinch of cardamom powder.',
          'Serve chilled.',
        ],
      ),
      Recipe(
        title: 'Jeera Rice',
        description: 'A simple and aromatic rice dish flavored with cumin seeds.',
        prepTime: 20, servings: 4, category: 'Lunch', difficulty: 'Easy',
        tags: ['rice', 'cumin', 'vegan'],
        ingredients: [
          Ingredient(name: 'Basmati rice', amount: 1, unit: 'cup'),
          Ingredient(name: 'Water', amount: 2, unit: 'cup'),
          Ingredient(name: 'Cumin seeds (Jeera)', amount: 1, unit: 'tbsp'),
          Ingredient(name: 'Ghee or Oil', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Wash and soak the rice for 15 minutes.',
          'Heat ghee/oil in a pot. Add cumin seeds and let them sizzle.',
          'Drain the rice and add it to the pot. Sauté for 1 minute.',
          'Add water and salt. Bring to a boil.',
          'Cover and cook on low heat for 10-12 minutes, or until all water is absorbed.',
          'Fluff with a fork and serve.',
        ],
      ),
      Recipe(
        title: 'Chole',
        description: 'A popular North Indian chickpea curry, full of flavor.',
        prepTime: 40, servings: 4, category: 'Dinner', difficulty: 'Medium',
        tags: ['chickpea', 'curry', 'vegan'],
        ingredients: [
          Ingredient(name: 'Chickpeas, boiled', amount: 2, unit: 'cup'),
          Ingredient(name: 'Onion, pureed', amount: 1, unit: 'piece'),
          Ingredient(name: 'Tomato, pureed', amount: 1, unit: 'cup'),
          Ingredient(name: 'Ginger-garlic paste', amount: 1, unit: 'tbsp'),
          Ingredient(name: 'Chole masala', amount: 2, unit: 'tbsp'),
          Ingredient(name: 'Oil', amount: 3, unit: 'tbsp'),
          Ingredient(name: 'Salt', amount: 1, unit: 'to taste'),
        ],
        instructions: [
          'Heat oil in a pan. Add the onion puree and cook until browned.',
          'Add ginger-garlic paste and cook for a minute.',
          'Add tomato puree and cook until oil separates.',
          'Add chole masala and salt. Mix well.',
          'Add the boiled chickpeas and 1 cup of water. Simmer for 15 minutes.',
          'Mash a few chickpeas to thicken the gravy.',
          'Serve hot with bhature or rice.',
        ],
      ),
    ];
  }

  static Future<void> populateSampleData(RecipeProvider provider) async {
    final sampleRecipes = getSampleRecipes();
    bool hasAdded = false;

    if (provider.recipes.isEmpty) {
      for (final recipe in sampleRecipes) {
        if (!provider.recipes.any((r) => r.title == recipe.title)) {
          await provider.addRecipe(recipe);
          hasAdded = true;
        }
      }
      if (kDebugMode && hasAdded) {
        print('${sampleRecipes.length} sample recipes have been added.');
      }
    }
  }
}