# My Recipe Book 🍲

A comprehensive and offline-first recipe management application built with Flutter, designed for storing and organizing your favorite Indian food recipes.

## App Showcase

### Home & Powerful Search
The main screen provides a vibrant, at-a-glance view of all recipes. It features an integrated search bar and a filterable list of collections. The search is powerful, allowing users to find recipes by title, description, or even by ingredients.

<p align="center">
  <img src="PASTE_YOUR_HOME_SCREEN_URL_HERE" width="250" alt="Home Screen">
  <img src="PASTE_YOUR_SEARCH_SCREEN_URL_HERE" width="250" alt="Search Screen">
</p>

### Full Recipe Management
The app features complete Create, Read, Update, and Delete (CRUD) functionality. Users can add new recipes with a detailed, user-friendly form or edit existing ones.

<p align="center">
  <img src="PASTE_YOUR_ADD_RECIPE_SCREEN_URL_HERE" width="250" alt="Add Recipe Screen">
  <img src="PASTE_YOUR_EDIT_RECIPE_SCREEN_URL_HERE" width="250" alt="Edit Recipe Screen">
</p>

### Interactive Details
The detail screen showcases the recipe with a large header image and clear instructions. It includes two key interactive features:
* **Dynamic Ingredient Scaling:** Users can increase or decrease the serving size, and all ingredient quantities are automatically recalculated in real-time.
* **Star Ratings:** Users can tap the rating to open a dialog and save their own rating for the recipe.

<p align="center">
  <img src="PASTE_YOUR_RECIPE_DETAIL_SCREEN_URL_HERE" width="250" alt="Recipe Detail Screen">
  <img src="PASTE_YOUR_SERVING_COUNTER_URL_HERE" width="250" alt="Serving Counter in Action">
  <img src="PASTE_YOUR_RATING_DIALOG_URL_HERE" width="250" alt="Rating Dialog">
</p>

### Powerful Organization with Collections & Favorites
Users can mark recipes as favorites for quick access in a dedicated tab. For more advanced organization, users can create their own custom collections, which can be edited and deleted.

<p align="center">
  <img src="PASTE_YOUR_COLLECTION_SCREEN_URL_HERE" width="250" alt="Collections Screen">
  <img src="PASTE_YOUR_FAVORITE_SCREEN_URL_HERE" width="250" alt="Favorites Screen">
  <img src="PASTE_YOUR_COLLECTION_DETAIL_SCREEN_URL_HERE" width="250" alt="Collection Detail Screen">
</p>

## Features

* **Full Recipe Management (CRUD):** Create, read, update, and delete recipes.
* **Detailed Recipe Information:** Title, description, ingredients, instructions, images, prep time, servings, and tags.
* **Interactive Recipe Viewing:** Dynamically scale ingredients with a servings counter and set star ratings.
* **Powerful Organization:** Create, edit, and delete personal collections.
* **Quick Collections:** Automatic, dynamic collections for "All Recipes", "Favorites", "Quick & Easy", and "New Recipes".
* **Advanced Search:** Find recipes by Title, Description, or Ingredient name.
* **Offline First:** All data is stored locally using the Hive database, making the app fully functional without an internet connection.

## Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Provider
* **Database:** Hive (Local, Key-Value NoSQL Database)
* **Key Packages:**
    * `image_picker`
    * `flutter_rating_bar`
    * `hive_generator` & `build_runner`
    * `uuid`
    * `provider`

## Getting Started

To run this project locally, follow these steps:

1.  Clone the repository.
2.  Navigate to the project directory.
3.  Get the dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the Hive code generator:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5.  Run the app:
    ```bash
    flutter run
    ```
