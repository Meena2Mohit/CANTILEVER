import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'data/sample_recipes.dart';
import 'models/recipe.dart';
import 'providers/recipe_provider.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';

Future<void> _initHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);

  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(RecipeCollectionAdapter());
  Hive.registerAdapter(IngredientAdapter());
  await Hive.openBox<Recipe>(DatabaseService.recipesBoxName);
  await Hive.openBox<RecipeCollection>(DatabaseService.collectionsBoxName);

  await DatabaseService.init();
}

void main() async {
  await _initHive();
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = RecipeProvider();
        provider.initialize().then((_) {
          SampleRecipes.populateSampleData(provider);
        });
        return provider;
      },
      child: MaterialApp(
        title: 'Recipe Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const _Bootstrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _Bootstrapper extends StatelessWidget {
  const _Bootstrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (_, provider, __) {
        if (!provider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading recipes…'),
                ],
              ),
            ),
          );
        }
        return const HomeScreen();
      },
    );
  }
}