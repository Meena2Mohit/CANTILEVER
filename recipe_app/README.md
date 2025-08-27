# My Recipe Book 🍲

A comprehensive and offline-first recipe management application built with Flutter, designed for storing and organizing your favorite Indian food recipes.

## App Showcase

### Home & Powerful Search
[cite_start]The main screen provides a vibrant, at-a-glance view of all recipes[cite: 84]. It features an integrated search bar and a filterable list of collections. [cite_start]The search is powerful, allowing users to find recipes by title, description, or even by ingredients[cite: 86].

<p align="center">
  <img src="http://googleusercontent.com/file_content/84" width="250" alt="Home Screen">
  <img src="http://googleusercontent.com/file_content/86" width="250" alt="Search Screen">
</p>

### Full Recipe Management
The app features complete Create, Read, Update, and Delete (CRUD) functionality. [cite_start]Users can add new recipes with a detailed, user-friendly form [cite: 90] [cite_start]or edit existing ones[cite: 87].

<p align="center">
  <img src="http://googleusercontent.com/file_content/90" width="250" alt="Add Recipe Screen">
  <img src="http://googleusercontent.com/file_content/87" width="250" alt="Edit Recipe Screen">
</p>

### Interactive Details
[cite_start]The detail screen showcases the recipe with a large header image and clear instructions[cite: 88]. It includes two key interactive features:
* [cite_start]**Dynamic Ingredient Scaling:** Users can increase or decrease the serving size, and all ingredient quantities are automatically recalculated in real-time[cite: 89].
* [cite_start]**Star Ratings:** Users can tap the rating to open a dialog and save their own rating for the recipe[cite: 92].

<p align="center">
  <img src="http://googleusercontent.com/file_content/88" width="250" alt="Recipe Detail Screen">
  <img src="http://googleusercontent.com/file_content/89" width="250" alt="Serving Counter in Action">
  <img src="http://googleusercontent.com/file_content/92" width="250" alt="Rating Dialog">
</p>

### Powerful Organization with Collections & Favorites
[cite_start]Users can mark recipes as favorites for quick access in a dedicated tab[cite: 85]. [cite_start]For more advanced organization, users can create their own custom collections, which can be edited and deleted[cite: 91, 93].

<p align="center">
  <img src="http://googleusercontent.com/file_content/91" width="250" alt="Collections Screen">
  <img src="http://googleusercontent.com/file_content/85" width="250" alt="Favorites Screen">
  <img src="http://googleusercontent.com/file_content/93" width="250" alt="Collection Detail Screen">
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