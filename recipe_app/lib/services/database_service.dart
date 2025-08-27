import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';

class DatabaseService {
  static const String recipesBoxName = 'recipesBox';
  static const String collectionsBoxName = 'collectionsBox';

  static Box<Recipe> get _recipesBox => Hive.box<Recipe>(recipesBoxName);
  static Box<RecipeCollection> get _collectionsBox =>
      Hive.box<RecipeCollection>(collectionsBoxName);

  static Future<void> init() async {
    await _createDefaultCollections();
  }

  static Future<void> saveRecipe(Recipe recipe) async {
    await _recipesBox.put(recipe.id, recipe);
  }

  static List<Recipe> getAllRecipes() {
    return _recipesBox.values.toList(growable: false);
  }

  static Recipe? getRecipe(String id) {
    return _recipesBox.get(id);
  }

  static Future<void> deleteRecipe(String id) async {
    await _recipesBox.delete(id);
    final updated = _collectionsBox.values.map((c) {
      if (c.recipeIds.contains(id)) {
        final nextIds = List<String>.from(c.recipeIds)..remove(id);
        return c.copyWith(recipeIds: nextIds);
      }
      return c;
    }).toList();

    for (final coll in updated) {
      await _collectionsBox.put(coll.id, coll);
    }
  }

  static Future<void> saveCollection(RecipeCollection collection) async {
    await _collectionsBox.put(collection.id, collection);
  }

  static List<RecipeCollection> getAllCollections() {
    return _collectionsBox.values.toList(growable: false);
  }

  static RecipeCollection? getCollection(String id) {
    return _collectionsBox.get(id);
  }

  static Future<void> deleteCollection(String id) async {
    if (isDefaultCollectionId(id)) return;
    await _collectionsBox.delete(id);
  }

  static Future<void> addRecipeToCollection({
    required String collectionId,
    required String recipeId,
  }) async {
    final coll = _collectionsBox.get(collectionId);
    if (coll == null) return;
    if (coll.recipeIds.contains(recipeId)) return;

    final next = List<String>.from(coll.recipeIds)..add(recipeId);
    await _collectionsBox.put(
      coll.id,
      coll.copyWith(recipeIds: next),
    );
  }

  static Future<void> removeRecipeFromCollection({
    required String collectionId,
    required String recipeId,
  }) async {
    final coll = _collectionsBox.get(collectionId);
    if (coll == null) return;
    if (!coll.recipeIds.contains(recipeId)) return;

    final next = List<String>.from(coll.recipeIds)..remove(recipeId);
    await _collectionsBox.put(
      coll.id,
      coll.copyWith(recipeIds: next),
    );
  }

  static Future<void> _createDefaultCollections() async {
    if (_collectionsBox.isNotEmpty) return;
    final allCollection = RecipeCollection(id: 'all_collection', name: 'All', emoji: '📚');
    await _collectionsBox.put(allCollection.id, allCollection);
  }

  static bool isDefaultCollectionId(String id) {
    return id == 'all_collection';
  }
}