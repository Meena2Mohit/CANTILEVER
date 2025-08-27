import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = <Recipe>[];
  List<RecipeCollection> _customCollections = <RecipeCollection>[];
  List<RecipeCollection> _defaultCollections = <RecipeCollection>[];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isInitialized = false;

  List<Recipe> get recipes => _recipes;
  List<RecipeCollection> get collections => [..._defaultCollections, ..._customCollections];
  List<RecipeCollection> get customCollections => _customCollections;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isInitialized => _isInitialized;

  List<RecipeCollection> get homeScreenFilterCollections {
    final allCollection = _defaultCollections.where((c) => c.id == 'all_collection');
    return [...allCollection, ..._customCollections];
  }

  Future<void> initialize() async {
    try {
      _recipes = DatabaseService.getAllRecipes();
      final allCollections = DatabaseService.getAllCollections();
      _defaultCollections = allCollections.where((c) => DatabaseService.isDefaultCollectionId(c.id)).toList();
      _customCollections = allCollections.where((c) => !DatabaseService.isDefaultCollectionId(c.id)).toList();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Error during RecipeProvider initialization: $e");
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    await DatabaseService.saveRecipe(recipe);
    _recipes = DatabaseService.getAllRecipes();
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await DatabaseService.saveRecipe(recipe);
    _recipes = DatabaseService.getAllRecipes();
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    await DatabaseService.deleteRecipe(id);
    _recipes.removeWhere((recipe) => recipe.id == id);
    _customCollections.forEach((collection) {
      collection.recipeIds.remove(id);
    });
    notifyListeners();
  }

  Future<void> addCollection(RecipeCollection collection) async {
    await DatabaseService.saveCollection(collection);
    _customCollections.add(collection);
    notifyListeners();
  }

  Future<void> updateCollection(RecipeCollection collection) async {
    await DatabaseService.saveCollection(collection);
    final index = _customCollections.indexWhere((c) => c.id == collection.id);
    if (index != -1) {
      _customCollections[index] = collection;
    }
    notifyListeners();
  }

  Future<void> deleteCollection(String id) async {
    await DatabaseService.deleteCollection(id);
    _customCollections.removeWhere((collection) => collection.id == id);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Recipe? getRecipe(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Recipe> getRecipesInCollection(String collectionId) {
    if (collectionId == 'all_collection') {
      return _recipes;
    }
    final allColl = [..._defaultCollections, ..._customCollections];
    final idx = allColl.indexWhere((c) => c.id == collectionId);
    if (idx == -1) return const [];
    final collection = allColl[idx];
    final ids = collection.recipeIds.toSet();
    return _recipes.where((r) => ids.contains(r.id)).toList(growable: false);
  }

  List<Recipe> get filteredRecipes {
    Iterable<Recipe> list = _recipes;
    if (_selectedCategory != 'All') {
      final allColl = [..._defaultCollections, ..._customCollections];
      final coll = allColl.where((c) => c.name == _selectedCategory);
      if (coll.isNotEmpty) {
        final collectionRecipes = getRecipesInCollection(coll.first.id);
        final ids = collectionRecipes.map((r) => r.id).toSet();
        list = list.where((r) => ids.contains(r.id));
      } else {
        list = const <Recipe>[];
      }
    }

    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((recipe) {
        final titleMatch = recipe.title.toLowerCase().contains(q);
        final descriptionMatch = recipe.description.toLowerCase().contains(q);
        final ingredientMatch = recipe.ingredients.any((ing) => ing.name.toLowerCase().contains(q));
        return titleMatch || descriptionMatch || ingredientMatch;
      });
    }

    return List<Recipe>.from(list);
  }
}