import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_manager/models/recipe.dart';
import 'package:recipe_manager/providers/recipe_provider.dart';
import 'package:recipe_manager/screens/add_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _currentServings;
  late List<Ingredient> _recalculatedIngredients;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      final recipe = provider.getRecipe(widget.recipeId);
      if (recipe != null) {
        _currentServings = recipe.servings;
        _recalculatedIngredients = List.from(recipe.ingredients);
        _isInitialized = true;
      }
    }
  }

  void _showRatingDialog(BuildContext context, Recipe recipe) {
    double tempRating = recipe.rating;
    final provider = Provider.of<RecipeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rate this recipe"),
          content: Center(
            heightFactor: 1,
            child: RatingBar.builder(
              initialRating: recipe.rating,
              minRating: 0,
              allowHalfRating: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                tempRating = rating;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final updatedRecipe = recipe.copyWith(rating: tempRating);
                provider.updateRecipe(updatedRecipe);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        final recipe = provider.getRecipe(widget.recipeId);
        if (recipe == null) {
          return const Scaffold(body: Center(child: Text('Recipe not found')));
        }
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8F0),
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, recipe, provider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (recipe.description.isNotEmpty)
                        Text(recipe.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700)),
                      const SizedBox(height: 16),
                      _buildInfoBar(context, recipe),
                      const Divider(height: 40, thickness: 1),
                      _buildSectionTitle('Ingredients (for $_currentServings servings)'),
                      _buildIngredientsList(_recalculatedIngredients),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Instructions'),
                      _buildInstructionsList(recipe.instructions),
                      const SizedBox(height: 24),
                      if (recipe.tags.isNotEmpty) ...[
                        _buildSectionTitle('Tags'),
                        _buildTags(recipe.tags),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBar(BuildContext context, Recipe recipe) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoButton(
            child: _buildInfoItem(context, Icons.timer_outlined, '${recipe.prepTime} min'),
          ),
          _buildInfoButton(
            child: _buildServingsChanger(recipe),
          ),
          _buildInfoButton(
            child: GestureDetector(
              onTap: () => _showRatingDialog(context, recipe),
              child: _buildInfoItem(context, Icons.star_border, recipe.rating.toStringAsFixed(1)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton({required Widget child}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ]
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildServingsChanger(Recipe recipe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.people_outline, color: Colors.deepOrange, size: 20),
        const SizedBox(width: 8),
        Text(
          '$_currentServings',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: InkWell(
                child: const Icon(Icons.arrow_drop_up, size: 22),
                onTap: () {
                  setState(() {
                    _currentServings++;
                    _recalculatedIngredients = recipe.getIngredientsForServings(_currentServings);
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
              width: 20,
              child: InkWell(
                child: const Icon(Icons.arrow_drop_down, size: 22),
                onTap: () {
                  if (_currentServings > 1) {
                    setState(() {
                      _currentServings--;
                      _recalculatedIngredients = recipe.getIngredientsForServings(_currentServings);
                    });
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Recipe recipe, RecipeProvider provider) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFFFFF8F0),
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white, size: 28),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildRecipeImage(recipe.imagePath, recipe.category),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            recipe.isFavorite = !recipe.isFavorite;
            provider.updateRecipe(recipe);
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddRecipeScreen(recipe: recipe),
              ));
            } else if (value == 'delete') {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Delete Recipe?'),
                    content: Text('Are you sure you want to delete "${recipe.title}"? This cannot be undone.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      TextButton(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          provider.deleteRecipe(recipe.id);
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(leading: Icon(Icons.delete_outline), title: Text('Delete')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipeImage(String? imagePath, String category) {
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('assets/')) {
        return Image.asset(imagePath, fit: BoxFit.cover);
      } else {
        return Image.file(File(imagePath), fit: BoxFit.cover);
      }
    }
    return Container(
        color: Colors.orange.shade100,
        child: Center(child: Text(_getRecipeEmoji(category), style: const TextStyle(fontSize: 80)))
    );
  }

  String _getRecipeEmoji(String category) {
    switch (category) {
      case 'Breakfast': return '🍳';
      case 'Lunch': return '🥗';
      case 'Dinner': return '🍽️';
      case 'Desserts': return '🍰';
      case 'Beverages': return '🥤';
      default: return '🍲';
    }
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.deepOrange, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildIngredientsList(List<Ingredient> ingredients) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredients.map((ing) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text('•  $ing', style: const TextStyle(fontSize: 16)),
        )).toList(),
      ),
    );
  }

  Widget _buildInstructionsList(List<String> instructions) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.deepOrange,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(instructions[index], style: const TextStyle(fontSize: 16, height: 1.4)),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
      ),
    );
  }

  Widget _buildTags(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((tag) => Chip(
          label: Text(tag),
          backgroundColor: Colors.orange.shade100,
          labelStyle: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w600),
          side: BorderSide.none,
        )).toList(),
      ),
    );
  }
}