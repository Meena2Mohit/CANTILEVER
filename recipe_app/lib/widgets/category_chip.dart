import 'package:flutter/material.dart';
import 'package:recipe_manager/models/recipe.dart';

class CategoryChip extends StatelessWidget {
  final RecipeCollection collection;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.collection,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(collection.name),
        avatar: Text(collection.emoji),
        backgroundColor: isSelected ? Colors.deepOrange : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}