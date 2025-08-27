import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe.dart';

class SelectableRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableRecipeCard({
    super.key,
    required this.recipe,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            width: 3,
          ),
        ),
        elevation: isSelected ? 8 : 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildRecipeImage(recipe.imagePath, recipe.category),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage(String? imagePath, String category) {
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('assets/')) {
        return Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      } else {
        return Image.file(File(imagePath), fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      }
    }
    return Center(child: Text(_getRecipeEmoji(category), style: const TextStyle(fontSize: 30)));
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
}