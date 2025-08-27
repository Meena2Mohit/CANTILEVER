import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<Ingredient> ingredients;

  @HiveField(4)
  List<String> instructions;

  @HiveField(5)
  String? imagePath;

  @HiveField(6)
  String category;

  @HiveField(7)
  int prepTime;

  @HiveField(8)
  int servings;

  @HiveField(9)
  double rating;

  @HiveField(10)
  bool isFavorite;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  DateTime updatedAt;

  @HiveField(13)
  String difficulty;

  @HiveField(14)
  List<String> tags;

  Recipe({
    String? id,
    required this.title,
    this.description = '',
    required this.ingredients,
    required this.instructions,
    this.imagePath,
    this.category = '',
    required this.prepTime,
    required this.servings,
    this.rating = 0.0,
    this.isFavorite = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.difficulty = 'Medium',
    this.tags = const [],
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get name => title;

  List<Ingredient> getIngredientsForServings(int newServings) {
    if (newServings <= 0 || servings <= 0) return ingredients;
    if (newServings == servings) return ingredients;

    final ratio = newServings / servings;
    return ingredients.map((ingredient) {
      return Ingredient(
        name: ingredient.name,
        amount: ingredient.amount * ratio,
        unit: ingredient.unit,
      );
    }).toList();
  }

  Recipe copyWith({
    String? title,
    String? description,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    String? imagePath,
    String? category,
    int? prepTime,
    int? servings,
    double? rating,
    bool? isFavorite,
    String? difficulty,
    List<String>? tags,
  }) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      prepTime: prepTime ?? this.prepTime,
      servings: servings ?? this.servings,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
    );
  }
}

@HiveType(typeId: 1)
class Ingredient extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String unit;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  @override
  String toString() {
    String formattedAmount = amount == amount.truncate()
        ? amount.truncate().toString()
        : amount.toStringAsFixed(1);
    return '$formattedAmount $unit $name';
  }
}

@HiveType(typeId: 2)
class RecipeCollection extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String emoji;

  @HiveField(3)
  List<String> recipeIds;

  @HiveField(4)
  final DateTime createdAt;

  RecipeCollection({
    String? id,
    required this.name,
    required this.emoji,
    List<String>? recipeIds,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        recipeIds = recipeIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  RecipeCollection copyWith({
    String? name,
    String? emoji,
    List<String>? recipeIds,
  }) {
    return RecipeCollection(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      recipeIds: recipeIds ?? this.recipeIds,
      createdAt: createdAt,
    );
  }
}