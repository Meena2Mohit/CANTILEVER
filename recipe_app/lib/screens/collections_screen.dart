import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'add_recipes_to_collection_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  void _showAddCollectionDialog(BuildContext context, {RecipeCollection? collectionToEdit}) {
    final isEditing = collectionToEdit != null;
    final nameController = TextEditingController(text: isEditing ? collectionToEdit.name : '');
    final emojiController = TextEditingController(text: isEditing ? collectionToEdit.emoji : '📚');
    final popularEmojis = ['🍕', '🍔', '🍝', '🍜', '🍰', '🍪', '🥗', '🌮'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isEditing ? 'Edit Collection' : 'Create New Collection',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: emojiController,
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          style: const TextStyle(fontSize: 24),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                          onChanged: (value) => setDialogState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Collection Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Suggestions:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: popularEmojis.map((emoji) {
                    final isSelected = emojiController.text == emoji;
                    return GestureDetector(
                      onTap: () {
                        emojiController.text = emoji;
                        setDialogState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple.withOpacity(0.2) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? Border.all(color: Colors.deepPurple, width: 2) : null,
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final provider = Provider.of<RecipeProvider>(context, listen: false);
                  if (isEditing) {
                    final updatedCollection = collectionToEdit.copyWith(
                      name: nameController.text.trim(),
                      emoji: emojiController.text.isNotEmpty ? emojiController.text : '📚',
                    );
                    await provider.updateCollection(updatedCollection);
                  } else {
                    final collection = RecipeCollection(
                      name: nameController.text.trim(),
                      emoji: emojiController.text.isNotEmpty ? emojiController.text : '📚',
                    );
                    await provider.addCollection(collection);
                  }
                  if (mounted) Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isEditing ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(String name, String emoji, int recipeCount,
      LinearGradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)) ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$recipeCount recipes',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        final customCollections = provider.customCollections;
        final allRecipes = provider.recipes;
        final favoriteRecipes = provider.recipes.where((r) => r.isFavorite).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Collections'),
            backgroundColor: Colors.white,
            elevation: 0.5,
            foregroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Collections', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    ...customCollections.map((collection) {
                      final gradient = _getGradientForCollection(collection.name);
                      return _buildCollectionCard(
                        collection.name,
                        collection.emoji,
                        provider.getRecipesInCollection(collection.id).length,
                        gradient,
                            () => _openCollectionDetail(context, collection, gradient),
                      );
                    }).toList(),
                    _buildAddCollectionCard(),
                  ],
                ),
                const SizedBox(height: 30),
                const Text('Quick Collections', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildQuickCollectionCard('Favorites', '❤️', favoriteRecipes.length, () => _openRecipesList(context, 'Favorite Recipes', favoriteRecipes)),
                    _buildQuickCollectionCard('All Recipes', '📚', allRecipes.length, () => _openRecipesList(context, 'All Recipes', allRecipes)),
                    _buildQuickCollectionCard('Quick & Easy', '⏱️', allRecipes.where((r) => r.prepTime <= 30).length, () => _openRecipesList(context, 'Quick & Easy Recipes', allRecipes.where((r) => r.prepTime <= 30).toList())),
                    _buildQuickCollectionCard('New Recipes', '✨', allRecipes.where((r) => DateTime.now().difference(r.createdAt).inDays <= 7).length, () => _openRecipesList(context, 'New Recipes', allRecipes.where((r) => DateTime.now().difference(r.createdAt).inDays <= 7).toList())),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddCollectionCard() {
    return GestureDetector(
      onTap: () => _showAddCollectionDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 32, color: Colors.grey.shade600),
            const SizedBox(height: 10),
            Text('Add Collection', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCollectionCard(
      String name, String emoji, int recipeCount, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)) ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
              Text('$recipeCount recipes', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradientForCollection(String name) {
    final gradients = [
      LinearGradient(colors: [Colors.orange.shade400, Colors.pink.shade300]),
      LinearGradient(colors: [Colors.purple.shade400, Colors.indigo.shade300]),
      LinearGradient(colors: [Colors.teal.shade400, Colors.green.shade300]),
      LinearGradient(colors: [Colors.red.shade400, Colors.orange.shade300]),
      LinearGradient(colors: [Colors.blue.shade400, Colors.cyan.shade300]),
    ];
    return gradients[name.hashCode % gradients.length];
  }

  void _openCollectionDetail(
      BuildContext context, RecipeCollection collection, LinearGradient gradient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeListScreen(
          collection: collection,
          gradient: gradient,
          onEditCollection: (collectionToEdit) {
            _showAddCollectionDialog(context, collectionToEdit: collectionToEdit);
          },
        ),
      ),
    );
  }

  void _openRecipesList(
      BuildContext context, String title, List<Recipe> recipes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StaticRecipeListScreen(title: title, recipes: recipes),
      ),
    );
  }
}

class StaticRecipeListScreen extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  const StaticRecipeListScreen({super.key, required this.title, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: recipes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 100, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text('No recipes in this collection', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(
            recipe: recipe,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipeId: recipe.id)),
              );
            },
          );
        },
      ),
    );
  }
}

class RecipeListScreen extends StatelessWidget {
  final RecipeCollection collection;
  final LinearGradient gradient;
  final Function(RecipeCollection) onEditCollection;

  const RecipeListScreen({
    super.key,
    required this.collection,
    required this.gradient,
    required this.onEditCollection,
  });

  void _showDeleteDialog(BuildContext context, RecipeProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Collection?'),
          content: Text('Are you sure you want to delete "${collection.name}"? This cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                provider.deleteCollection(collection.id);
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openManageRecipesScreen(BuildContext context, RecipeProvider provider) {
    final freshCollection = provider.collections.firstWhere((c) => c.id == collection.id, orElse: () => collection);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipesToCollectionScreen(collection: freshCollection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        final currentCollection = provider.customCollections.firstWhere((c) => c.id == collection.id, orElse: () => collection);
        final recipes = provider.getRecipesInCollection(currentCollection.id);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(gradient: gradient),
              child: AppBar(
                title: Text(currentCollection.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_note),
                    tooltip: 'Edit Collection Name/Emoji',
                    onPressed: () => onEditCollection(currentCollection),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete Collection',
                    onPressed: () => _showDeleteDialog(context, provider),
                  ),
                ],
              ),
            ),
          ),
          body: recipes.isEmpty
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 20),
                  Text('No recipes in this collection yet.', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'Tap the button below to add recipes!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ))
              : GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 15, mainAxisSpacing: 15),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                recipe: recipe,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipeId: recipe.id)),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openManageRecipesScreen(context, provider),
            label: const Text('Organize Collection'),
            icon: const Icon(Icons.playlist_add),
          ),
        );
      },
    );
  }
}