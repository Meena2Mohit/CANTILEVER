import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_manager/models/recipe.dart';
import 'package:recipe_manager/providers/recipe_provider.dart';
import 'package:recipe_manager/widgets/selectable_recipe_card.dart';

class AddRecipesToCollectionScreen extends StatefulWidget {
  final RecipeCollection collection;

  const AddRecipesToCollectionScreen({
    super.key,
    required this.collection,
  });

  @override
  State<AddRecipesToCollectionScreen> createState() => _AddRecipesToCollectionScreenState();
}

class _AddRecipesToCollectionScreenState extends State<AddRecipesToCollectionScreen> {
  final Set<String> _selectedRecipeIds = <String>{};

  @override
  void initState() {
    super.initState();
    _selectedRecipeIds.addAll(widget.collection.recipeIds);
  }

  Future<void> _saveSelection(BuildContext context) async {
    final provider = context.read<RecipeProvider>();

    final updatedCollection = widget.collection.copyWith(
      recipeIds: _selectedRecipeIds.toList(),
    );

    await provider.updateCollection(updatedCollection);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.collection.name}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () => _saveSelection(context),
              child: const Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, _) {
          final recipes = provider.recipes;
          if (recipes.isEmpty) {
            return const Center(
              child: Text('You have no recipes to add.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final isSelected = _selectedRecipeIds.contains(recipe.id);
              return SelectableRecipeCard(
                recipe: recipe,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedRecipeIds.remove(recipe.id);
                    } else {
                      _selectedRecipeIds.add(recipe.id);
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}