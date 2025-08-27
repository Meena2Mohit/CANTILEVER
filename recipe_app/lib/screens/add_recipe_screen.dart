import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:recipe_manager/providers/recipe_provider.dart';
import 'package:recipe_manager/models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const AddRecipeScreen({super.key, this.recipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientAmountController = TextEditingController();
  final _ingredientUnitController = TextEditingController();
  final _instructionController = TextEditingController();
  final _tagController = TextEditingController();

  late final ScrollController _scrollController;
  late final FocusNode _ingredientFocusNode;
  late final FocusNode _instructionFocusNode;
  late final FocusNode _tagFocusNode;

  String _selectedDifficulty = 'Medium';
  List<Ingredient> _ingredients = [];
  List<String> _instructions = [];
  List<String> _tags = [];
  String? _imagePath;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> _units = ['gm', 'kg', 'ml', 'l', 'cup', 'tsp', 'tbsp', 'piece', 'slice', 'packet', 'to taste'];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _ingredientFocusNode = FocusNode();
    _instructionFocusNode = FocusNode();
    _tagFocusNode = FocusNode();

    _ingredientFocusNode.addListener(_scrollToBottomOnFocus);
    _instructionFocusNode.addListener(_scrollToBottomOnFocus);
    _tagFocusNode.addListener(_scrollToBottomOnFocus);

    if (widget.recipe != null) {
      _populateFormForEdit();
    } else {
      _servingsController.text = '4';
      _prepTimeController.text = '30';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ingredientFocusNode.removeListener(_scrollToBottomOnFocus);
    _instructionFocusNode.removeListener(_scrollToBottomOnFocus);
    _tagFocusNode.removeListener(_scrollToBottomOnFocus);
    _ingredientFocusNode.dispose();
    _instructionFocusNode.dispose();
    _tagFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _servingsController.dispose();
    _ingredientNameController.dispose();
    _ingredientAmountController.dispose();
    _ingredientUnitController.dispose();
    _instructionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _scrollToBottomOnFocus() {
    if (_ingredientFocusNode.hasFocus || _instructionFocusNode.hasFocus || _tagFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _populateFormForEdit() {
    final recipe = widget.recipe!;
    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _prepTimeController.text = recipe.prepTime.toString();
    _servingsController.text = recipe.servings.toString();
    _selectedDifficulty = recipe.difficulty;
    _ingredients = List.from(recipe.ingredients.map((ing) => Ingredient(name: ing.name, amount: ing.amount, unit: ing.unit)));
    _instructions = List.from(recipe.instructions);
    _tags = List.from(recipe.tags);
    _imagePath = recipe.imagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}${p.extension(image.path)}';
    final targetPath = p.join(appDir.path, fileName);

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 60,
    );

    if (compressedFile != null) {
      if (_imagePath != null && !_imagePath!.startsWith('assets/')) {
        final oldFile = File(_imagePath!);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }
      setState(() {
        _imagePath = compressedFile.path;
      });
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipeData = Recipe(
        id: widget.recipe?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: _ingredients,
        instructions: _instructions,
        imagePath: _imagePath,
        prepTime: int.tryParse(_prepTimeController.text) ?? 30,
        servings: int.tryParse(_servingsController.text) ?? 4,
        rating: widget.recipe?.rating ?? 0.0,
        isFavorite: widget.recipe?.isFavorite ?? false,
        difficulty: _selectedDifficulty,
        tags: _tags,
        createdAt: widget.recipe?.createdAt,
      );

      final provider = Provider.of<RecipeProvider>(context, listen: false);

      if (widget.recipe != null) {
        provider.updateRecipe(recipeData);
      } else {
        provider.addRecipe(recipeData);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipe != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Recipe' : 'Add New Recipe'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: _saveRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildTextField(controller: _titleController, label: 'Recipe Title', hint: 'Enter recipe name...'),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Brief description of the recipe...',
                maxLines: 3,
                isRequired: false,
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildDifficultyDropdown()),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(controller: _prepTimeController, label: 'Prep Time (min)', hint: '30', keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 20),
              _buildTextField(controller: _servingsController, label: 'Servings', hint: '4', keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              _buildSectionTitle('Ingredients'),
              _buildIngredientsSection(),
              const SizedBox(height: 30),
              _buildSectionTitle('Instructions'),
              _buildInstructionsSection(),
              const SizedBox(height: 30),
              _buildSectionTitle('Tags'),
              _buildTagsSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _imagePath != null && _imagePath!.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: _imagePath!.startsWith('assets/')
              ? Image.asset(_imagePath!, fit: BoxFit.cover)
              : Image.file(File(_imagePath!), fit: BoxFit.cover),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text('Add Photo', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: isRequired
              ? (value) => value == null || value.isEmpty ? '$label is required' : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDifficultyDropdown() => _buildDropdown('Difficulty', _selectedDifficulty, _difficulties, (val) => setState(() => _selectedDifficulty = val!));

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      children: [
        ..._ingredients.asMap().entries.map((entry) => _buildListItem(entry.value.toString(), () => setState(() => _ingredients.removeAt(entry.key)))),
        _buildAdderCard(
          children: [
            TextFormField(controller: _ingredientNameController, focusNode: _ingredientFocusNode, decoration: const InputDecoration(labelText: 'Ingredient name')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: TextFormField(controller: _ingredientAmountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount'))),
              const SizedBox(width: 10),
              Expanded(child: DropdownButtonFormField<String>(
                value: _ingredientUnitController.text.isEmpty ? null : _ingredientUnitController.text,
                hint: const Text('Unit'),
                onChanged: (value) => _ingredientUnitController.text = value ?? '',
                items: _units.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
              )),
            ]),
          ],
          onAdd: _addIngredient,
          buttonLabel: 'Add Ingredient',
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      children: [
        ..._instructions.asMap().entries.map((entry) => _buildListItem('${entry.key + 1}. ${entry.value}', () => setState(() => _instructions.removeAt(entry.key)))),
        _buildAdderCard(
          children: [
            TextFormField(controller: _instructionController, focusNode: _instructionFocusNode, maxLines: 3, decoration: const InputDecoration(labelText: 'New step...')),
          ],
          onAdd: _addInstruction,
          buttonLabel: 'Add Instruction',
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_tags.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _tags.map((tag) => Chip(label: Text(tag), onDeleted: () => setState(() => _tags.remove(tag)))).toList(),
          ),
        _buildAdderCard(
          children: [
            TextField(controller: _tagController, focusNode: _tagFocusNode, decoration: const InputDecoration(labelText: 'New tag...'), onSubmitted: (_) => _addTag()),
          ],
          onAdd: _addTag,
          buttonLabel: 'Add Tag',
        ),
      ],
    );
  }

  Widget _buildListItem(String text, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Expanded(child: Text(text)),
        IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
      ]),
    );
  }

  Widget _buildAdderCard({required List<Widget> children, required VoidCallback onAdd, required String buttonLabel}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ...children,
            const SizedBox(height: 15),
            ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }

  void _addIngredient() {
    if (_ingredientNameController.text.isNotEmpty && _ingredientAmountController.text.isNotEmpty && _ingredientUnitController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(Ingredient(
          name: _ingredientNameController.text.trim(),
          amount: double.tryParse(_ingredientAmountController.text) ?? 0,
          unit: _ingredientUnitController.text,
        ));
        _ingredientNameController.clear();
        _ingredientAmountController.clear();
        _ingredientUnitController.clear();
        _ingredientFocusNode.unfocus();
      });
    }
  }

  void _addInstruction() {
    if (_instructionController.text.isNotEmpty) {
      setState(() {
        _instructions.add(_instructionController.text.trim());
        _instructionController.clear();
        _instructionFocusNode.unfocus();
      });
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
        _tagFocusNode.unfocus();
      });
    }
  }
}